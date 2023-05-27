setwd("~/wndus1712@gmail.com - Google Drive/내 드라이브/Lecture/02_BayesianAdv/hw3")
getwd()
library(rstan); library(ggplot2); library(dplyr)

data('Orange')
head(Orange)
summary(Orange) # 35 by 3
class(Orange$Tree)
class(Orange$age)
class(Orange$circumference)

######################################################################
## 
## Model (1): assume homoscedasticity
## 
######################################################################

######################################################################
# 1. EDA  
######################################################################
colors = c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD")

Orange %>% 
  mutate(Tree = as.factor(Tree)) %>%
  ggplot(aes(x=age, y=circumference, group=Tree, color=Tree)) + 
  geom_point(size=2) +
  geom_line() + 
  scale_color_manual(values = colors) +
  labs(x='age',
       y='circumference',
       color='Tree',
       title='Tree circumference w.r.t. age') +
  theme_minimal()

## Check homoscedastic assumption
tree_means <- aggregate(Orange$circumference, by=list(Tree=Orange$Tree), FUN=mean)
tree_sd <- aggregate(Orange$circumference, by=list(Tree=Orange$Tree), FUN=sd)
tree_stat <- data.frame(tree_means, tree_sd$x)
colnames(tree_stat) <- c('Tree', 'group_mean', 'group_sd')
print(tree_stat)

######################################################################
# 2. Model  
# Group indicator: Orange$Tree
# predictor variable: Orange$age
# response variable: Orange$circumference
# number of observations: n=35
# number of group: L=5
# number of predictor variable: p=1
# prior
# - noninformative prior for beta1, beta2, beta3
# - informative prior for tau1, tau2
######################################################################
## Define model 
stanmodel <- "
data {
  int<lower=0> N;              // num of observation 35
  int<lower=1> L;              // num of group 5
  real<lower=0> y[N];          // response variable
  int<lower=1,upper=L> ll[N];  // group indicator
  real x[N];                   // predictor variable
}
parameters {
  real<lower=0> tau1;  // var of random effect u[L] (scalar, because of homoscedasticity)
  real<lower=0> tau2;  // var of epsilon
  real beta1;          // fixed effect
  real beta2;          // fixed effect
  real beta3;          // fixed effect
  real u[L];           // mixed effect 
}
transformed parameters {
  real tau;
  real sigma;  // normal function in stan gets std for scale parameter
  real m[N];
  for (i in 1:N){
    m[i] = (beta1 + u[ll[i]]) / (1 + exp(-(x[i] - beta2) / beta3));
  }
  sigma = 1 / sqrt(tau2);
  tau = 1 / sqrt(tau1);
}
model {
  // priors for fixed effect
  beta1 ~ normal(0.0, 1000);
  beta2 ~ normal(0.0, 1000);
  beta3 ~ normal(0.0, 1000);  // noninformative prior
  tau2 ~ gamma(0.3, 0.5);
  // prior for random effect
  tau1 ~ gamma(0.01, 0.01);
  for (l in 1:L){
    u[l] ~ normal(0, tau);
  }
  // likelihood
  for (n in 1:N){
   y[n] ~ normal(m[n], sigma); 
  }
}
generated quantities{
  // calculated when the mcmc sampling is done
  real y_mean[N];
  real y_rep[N];
  //real ppp_value_group_mean;
  for(i in 1:N){
    // Posterior parameter distribution of the mean
    y_mean[i] = (beta1 + u[ll[i]]) / (1 + exp(-(x[i] - beta2) / beta3));
    // Posterior predictive distribution
    y_rep[i] = normal_rng(y_mean[i], sigma);
  }
}"

## Model fitting
n = 35; L = 5
data = list(y=Orange$circumference,
            N=n,
            L=L,
            x=Orange$age,
            ll=as.integer(Orange$Tree)
)

fit <- stan(
  model_code = stanmodel, 
  data = data, 
  chain = 4,
  warmup = 2000, 
  iter = 3000,
  cores = 4
)

print(fit)

######################################################################
## 3. Model diagnostic
######################################################################
## Convergence diagnostic
# a. traceplot
traceplot(fit,pars=c("beta1", "beta2", "beta3", "sigma", "tau"))

# b. histogram of parameters
param = extract(fit)
par(mfrow=c(2, 3))
hist(param$beta1, breaks=40, main='beta1', xlab='')
abline(v=mean(param$beta1), col='red', lwd=2)
hist(param$beta2, breaks=40, main='beta2', xlab='')
abline(v=mean(param$beta2), col='red', lwd=2)
hist(param$beta3, breaks=40, main='beta3', xlab='')
abline(v=mean(param$beta3), col='red', lwd=2)
hist(param$sigma, breaks=40, main='sigma^2', xlab='')
abline(v=mean(param$sigma), col='red', lwd=2)
hist(param$tau, breaks=40, main='tau^2', xlab='')
abline(v=mean(param$tau), col='red', lwd=2)

## Visualize
y_mean <- extract(fit, "y_mean")
y_mean_cred <- apply(y_mean$y_mean, 2, quantile, c(0.05, 0.95))
y_mean_mean <- apply(y_mean$y_mean, 2, mean)

y_rep <- extract(fit, "y_rep")
y_rep_cred <- apply(y_rep$y_rep, 2, quantile, c(0.05, 0.95))
y_rep_mean <- apply(y_rep$y_rep, 2, mean)  ## y replicated 

df <- data.frame(
  age = Orange$age,
  circumference = Orange$circumference,
  group = as.factor(Orange$Tree),
  lower = y_mean_cred[1,], # Assuming this is the lower bound of the CI
  upper = y_mean_cred[2,],  # Assuming this is the upper bound of the CI
  mean_prediction = y_mean_mean
)

ggplot(df, aes(x=age, y=circumference, group=group, color=group)) +
  geom_ribbon(aes(ymin=lower, ymax=upper, fill=group), alpha=0.2) +
  geom_point(size=2) +
  geom_line(aes(y=mean_prediction), linetype="dashed", color="black") + 
  geom_line() +
  scale_color_manual(values = colors) +
  scale_fill_manual(values = colors) +
  labs(x='age',
       y='circumference',
       color='Tree',
       fill='Tree',
       title='Nonlinear Mixed model') +
  theme_minimal()

######################################################################
## 4. Posterior predictive check
######################################################################
## Posterior predictive check
par(mfrow=c(1,1))
res.obs=sqrt(colMeans((Orange$circumference - t(y_mean$y_mean))^2))
res.rep=sqrt(rowMeans((y_rep$y_rep-y_mean$y_mean)^2))	# just same as the posterior dist of sigma; hist(1/sqrt(param$tau))
plot(res.obs,res.rep); abline(a=0,b=1,col="red")

chisq.obs=colMeans((Orange$circumference - t(y_mean$y_mean))^2/t(y_mean$y_mean))
chisq.rep=rowMeans((y_rep$y_rep-y_mean$y_mean)^2/y_mean$y_mean)
plot(chisq.obs,chisq.rep); abline(a=0,b=1,col="red")

## Posterior predictive p-value
# Group matrix
group <- matrix(0, n_mcmc, 35)
for (i in 1:n_mcmc){
  group[i, ] <- Orange$Tree
}
# Define residual test quantity
group_diff_ss_rep <- rep(0, n_mcmc)
group_diff_ss_obs <- rep(0, n_mcmc)
for(k in 1:n_mcmc){
  # within group variability of estimated y and replicated y
  group_sd_mean <- rep(0, 5)
  group_sd_rep <- rep(0, 5)
  group_sd_obs <- rep(0, 5)
  for(i in 1:5){
    group_sd_mean[i] <- sd(y_mean$y_mean[k, ][group[k, ] == i])
    group_sd_rep[i] <- sd(y_rep$y_rep[k, ][group[k, ] == i])
    group_sd_obs[i] <- sd(Orange$circumference[group[k, ] == i])
  }
  # sum of squared within group variability
  group_diff_rep <- group_sd_rep - group_sd_mean
  group_diff_obs <- group_sd_obs - group_sd_mean
  group_diff_ss_rep[k] <- (t(group_diff_rep) %*% group_diff_rep)/5
  group_diff_ss_obs[k] <- (t(group_diff_obs) %*% group_diff_obs)/5
}

# predictive posterior p value
mean(group_diff_ss_rep > group_diff_ss_obs)



######################################################################
## 
## Model (c): assume heteroscedasticity
## epsilon_i ~ N(0, sigma^2_i), i = 1, ..., m (# group)
## 
######################################################################

######################################################################
## 1. Model  
######################################################################
## Define model 
stanmodel <- "
data {
  int<lower=0> N;              // num of observation 35
  int<lower=1> L;              // num of group 5
  real<lower=0> y[N];          // response variable
  int<lower=1,upper=L> ll[N];  // group indicator
  real x[N];                   // predictor variable
}
parameters {
  real<lower=0> tau1;     // variance for random effect ui
  real<lower=0> tau2[L];  // var of epsilon, no homoscedasticity assumption
  real beta1;          // fixed effect
  real beta2;          // fixed effect
  real beta3;          // fixed effect
  real u[L];           // mixed effect 
}
transformed parameters {
  real tau;
  real sigma[L];  // normal function in stan gets std for scale parameter
  real sigma_temp[N];  // for sampling y
  real m[N];
  
  tau = 1 / sqrt(tau1);
  for (l in 1:L){
    sigma[l] = 1 / sqrt(tau2[l]);
  }
  for (i in 1:N){
    m[i] = (beta1 + u[ll[i]]) / (1 + exp(-(x[i] - beta2) / beta3));
    sigma_temp[i] = sigma[ll[i]];
  }
}
model {
  // priors for fixed effect
  beta1 ~ normal(0.0, 1000);
  beta2 ~ normal(0.0, 1000);
  beta3 ~ normal(0.0, 1000);  // noninformative prior

  // prior for random effect
  tau1 ~ gamma(0.01, 0.01);
  for (l in 1:L){
    u[l] ~ normal(0, tau);
  }
  
  // likelihood
  for (i in 1:N){
    y[i] ~ normal(m[i], sigma_temp[i]); 
  }
}
generated quantities{
  // calculated when the mcmc sampling is done
  real y_mean[N];
  real y_rep[N];
  //real ppp_value_group_mean;
  for(i in 1:N){
    // Posterior parameter distribution of the mean
    y_mean[i] = (beta1 + u[ll[i]]) / (1 + exp(-(x[i] - beta2) / beta3));
    // Posterior predictive distribution
    y_rep[i] = normal_rng(y_mean[i], sigma_temp[i]);
  }
}"

## Model fitting
n = 35; L = 5
data = list(y=Orange$circumference,
            N=n,
            L=L,
            x=Orange$age,
            ll=as.integer(Orange$Tree)
)

fit <- stan(
  model_code = stanmodel, 
  data = data, 
  chain = 4,
  warmup = 2000, 
  iter = 3000,
  cores = 4
)

print(fit)

######################################################################
## 2. Model diagnostic
######################################################################
## Convergence diagnostic
## a. traceplot
traceplot(fit,pars=c("sigma[1]", 'sigma[2]', 'sigma[3]', 'sigma[4]', 'sigma[5]',
                     'tau1', 'beta1', 'beta2', 'beta3'))

## b. histogram of parameters
param = extract(fit)
par(mfrow=c(2, 3))
hist(param$sigma[, 1], breaks=40, main='sigma[1]', xlab='')
abline(v=mean(param$sigma[, 1]), col='red', lwd=2)
hist(param$sigma[, 2], breaks=40, main='sigma[2]', xlab='')
abline(v=mean(param$sigma[, 1]), col='red', lwd=2)
hist(param$sigma[, 3], breaks=40, main='sigma[3]', xlab='')
abline(v=mean(param$sigma[, 1]), col='red', lwd=2)
hist(param$sigma[, 4], breaks=40, main='sigma[4]', xlab='')
abline(v=mean(param$sigma[, 1]), col='red', lwd=2)
hist(param$sigma[, 5], breaks=40, main='sigma[5]', xlab='')
abline(v=mean(param$sigma[, 1]), col='red', lwd=2)
par(mfrow=c(2, 2))
hist(param$tau1, breaks=40, main='tau1', xlab='')
abline(v=mean(param$tau1), col='red', lwd=2)
hist(param$beta1, breaks=40, main='beta1', xlab='')
abline(v=mean(param$beta1), col='red', lwd=2)
hist(param$beta2, breaks=40, main='beta2', xlab='')
abline(v=mean(param$beta2), col='red', lwd=2)
hist(param$beta3, breaks=40, main='beta3', xlab='')
abline(v=mean(param$beta3), col='red', lwd=2)

## Visualize
y_mean <- extract(fit, "y_mean")
y_mean_cred <- apply(y_mean$y_mean, 2, quantile, c(0.05, 0.95))
y_mean_mean <- apply(y_mean$y_mean, 2, mean)

y_rep <- extract(fit, "y_rep")
y_rep_cred <- apply(y_rep$y_rep, 2, quantile, c(0.05, 0.95))
y_rep_mean <- apply(y_rep$y_rep, 2, mean)  ## y replicated 

df <- data.frame(
  age = Orange$age,
  circumference = Orange$circumference,
  group = as.factor(Orange$Tree),
  lower = y_mean_cred[1,], # Assuming this is the lower bound of the CI
  upper = y_mean_cred[2,],  # Assuming this is the upper bound of the CI
  mean_prediction = y_mean_mean
)

ggplot(df, aes(x=age, y=circumference, group=group, color=group)) +
  geom_ribbon(aes(ymin=lower, ymax=upper, fill=group), alpha=0.2) +
  geom_point(size=2) +
  geom_line(aes(y=mean_prediction), linetype="dashed", color="black") + 
  geom_line() +
  scale_color_manual(values = colors) +
  scale_fill_manual(values = colors) +
  labs(x='age',
       y='circumference',
       color='Tree',
       fill='Tree',
       title='Nonlinear Mixed model') +
  theme_minimal()

######################################################################
## 3. Posterior predictive check
######################################################################
## Posterior predictive check
par(mfrow=c(1,1))
res.obs=sqrt(colMeans((Orange$circumference - t(y_mean$y_mean))^2))
res.rep=sqrt(rowMeans((y_rep$y_rep-y_mean$y_mean)^2))	# just same as the posterior dist of sigma; hist(1/sqrt(param$tau))
plot(res.obs,res.rep); abline(a=0,b=1,col="red")

chisq.obs=colMeans((Orange$circumference - t(y_mean$y_mean))^2/t(y_mean$y_mean))
chisq.rep=rowMeans((y_rep$y_rep-y_mean$y_mean)^2/y_mean$y_mean)
plot(chisq.obs,chisq.rep); abline(a=0,b=1,col="red")

## Posterior predictive p-value
# Group matrix
group <- matrix(0, n_mcmc, 35)
for (i in 1:n_mcmc){
  group[i, ] <- Orange$Tree
}
# Define residual test quantity
group_diff_ss_rep <- rep(0, n_mcmc)
group_diff_ss_obs <- rep(0, n_mcmc)
for(k in 1:n_mcmc){
  # within group variability of estimated y and replicated y
  group_sd_mean <- rep(0, 5)
  group_sd_rep <- rep(0, 5)
  group_sd_obs <- rep(0, 5)
  for(i in 1:5){
    group_sd_mean[i] <- sd(y_mean$y_mean[k, ][group[k, ] == i])
    group_sd_rep[i] <- sd(y_rep$y_rep[k, ][group[k, ] == i])
    group_sd_obs[i] <- sd(Orange$circumference[group[k, ] == i])
  }
  # sum of squared within group variability
  group_diff_rep <- group_sd_rep - group_sd_mean
  group_diff_obs <- group_sd_obs - group_sd_mean
  group_diff_ss_rep[k] <- (t(group_diff_rep) %*% group_diff_rep)/5
  group_diff_ss_obs[k] <- (t(group_diff_obs) %*% group_diff_obs)/5
}

# predictive posterior p value
mean(group_diff_ss_rep > group_diff_ss_obs)
