# Advanced_Bayesian_Methods
Advanced Bayesian Methods (STA9105)

Each file has a theoretical and computational problem about advance bayesian methods.
All analytical derivations are in pdf files and the computational works are contained in ipynb files.

## 1. Bayesian Linear regression 
## 2. Hierarchical Linear models
### 2-1. Model outline
- The mixed linear model (=hierarchical linear model) with multidimensional random effects
  - Let $y_j \in \mathbb{R^{n^j}}$ and $X_j \in \mathbb{R^{n_j \times d}}$ be the observation vector and the design matrix for subject $j = 1, \dots, m$, respectively. Using subject-specific random effects $\beta_j \in \mathbb{R}^d$, we can write a mixed eeffect model as
$$\begin{aligned} y_j \sim N_{n_j}(X_j\beta_j, \sigma^2 I_{n_j}), \beta_j \sim N_d(\mu_{\beta}, \Sigma_{\beta}), j =1, \dots, m \end{aligned}$$  
with $\sigma^2 > 0, \mu_{\beta} \in \mathbb{R}^d$, and $\Sigma_{\beta} \in \mathbb{R}^{d \times d}$ (positive definite).

### 2-2. Drive conditional posterior
- Full derivation is describe in 'Solution for analytical questions.pdf'

### 2-3. Gibbs sampling and posterior check
#### a. prior
- Give vague prior $\mu_{\beta}$ and $\sigma^2$  
- $\mu_{\beta} \sim \text{N}_2 \left( \xi, \Omega \right) \in \mathbb{R}^2$  
- $\sigma^2 \sim \text{Inv-}\chi^2 \left( \nu, \tau^2 \right) \in \mathbb{R}$  $\rightarrow$ (for vague prior) $\sigma^2 \sim \text{Inv-} \chi^2(3, 10`)$ 
- $\Sigma_{\beta} \sim \text{Wishart}\left(\Psi^{-1}, \rho \right) \in \mathbb{R}^{2 \times 2}$ $\rightarrow$ (for vague prior)  $\mu_{\beta} \sim \text{N}_d(0, 10 I_d)$ 
   
#### b. full conditional distribution
- $\beta_j|\sigma^2, \mu_{\beta}, \Sigma_{\beta}, y \sim \text{N}_{2} \left( \frac{1}{\sigma^2}(X_j'X_j + \Sigma_{\beta}^{-1})^{-1}(\frac{1}{\sigma^2}y_j' X_j + \mu_{\beta}' \Sigma_{\beta}^{-1})', (\frac{1}{\sigma^2}X_j'X_j + \Sigma_{\beta}^{-1})^{-1}       \right) \in \mathbb{R}^{2}$  
- $\sigma^2 | \beta, \mu_{\beta}, \Sigma_{\beta}, y \sim \text{Inv-}\chi^2 \left(N + \nu, \frac{1}{N + \nu}(y-X\beta)'(y-X\beta) + \nu \tau^2 \right) \in \mathbb{R}$  
- $\mu_{\beta} | \beta, \sigma^2, \Sigma_{\beta}, y \sim \text{N}_{10} \left((m \Sigma_{\beta}^{-1} + \Omega^{-1})^{-1}(\sum_{j=1}^{30}{(\beta_j' \Sigma_{\beta}^{-1}}) + \xi' \Omega^{-1})', (m \Sigma_{\beta}^{-1} + \Omega^{-1})^{-1}\right) \in \mathbb{R}^2$  
- $\Sigma_{\beta} | \beta, \sigma^2 \mu_{\beta}, y \sim \text{Inv-Wishart}\left( \sum_{j=1}^{30}(\beta_j - \mu_{\beta})(\beta_j - \mu_{\beta})') + \Psi, m + \rho \right)$  

#### c. Posterior predictive check
1. Generating replicated data $y^{rep}$ (Contained in gibbs sampler)
    - $p(y^{rep} | y) = \int p(y^{rep}|\theta)p(\theta|y)$
    - sampling $y^{rep (s)}$ using $\theta^{(s)}$ in $s$ iteration -> Get posterior simulations of $(\theta^{(s)}, y^{rep})$
2. Compare graphical plots such as the distribution of $y$ and $y^{rep}$
3. Conduct the posterior predictive check using residual teste quantitiy for regression
    - $p_B = \int \int \mathbb{1}_{T(y^{rep}|\theta) \geq T(y|\theta)} p(y^{rep} | \theta) p (\theta | y) dy^{rep} d\theta  = \mathbb{E} \left( \mathbb{1}_{T(y^{rep}|\theta) \geq T(y|\theta)} \right) \approx \frac{1}{N}\sum_{s=1}^{S}\mathbb{1}_{T(y^{rep (s)}|\theta^{(s)} \geq T(y|\theta^{(s)})}$

## 3. Generalized Linear models
### 3-1. Probit model outline
  $$\begin{aligned} p(y|X, \beta, \pi) = \text{exp} \left( \sum_{i=1}^{n} L(y_i | \eta_i, \pi)\right) \end{aligned}$$  
### 3-2. Normal Approximation
- The exponential family is easy to approximate to the normal distribution

- Likelihood is approximated as
  - $p(y | X, \beta, \phi) \propto \text{N}(\beta | \hat{\beta}, V)$, where
  -  $\hat{\beta}$ is MLE, $V = \left[ X' \text{diag}(-L''(y_i | \hat{\eta_i})) X \right]^{-1}$  
  - $L''(y_i | \hat{\eta_i}) =  y_i \frac{(-(X_i\hat{\beta}) \phi(X_i\hat{\beta})\Phi(X_i\hat{\beta}) - \phi(X_i\hat{\beta})^2)}{\Phi(X_i\hat{\beta})^2} + (n_i - y_i) \frac{\phi(X_i\hat{\beta})^2 + (X_i\hat{\beta}) \phi(X_i\hat{\beta})(1 - \Phi(X_i\hat{\beta}))}{(1 - \Phi(X_i\hat{\beta}))^2} $  
- Posterior is approximated as
  - $p(\beta | \phi, y) \propto \text{N}(\beta| \hat{\beta}_{pos}, V_{pos})$, where  
  - $V_{pos} = V, \hat{\beta}_{pos} = \hat{\beta}$ if $p(\beta) \propto 1$ (noninformative prior)  

### 3-3. Methods to obtain posterior distribution of $\beta$

#### a. Independent Metropolis-Hastings 
- Posterior: $p(\beta | \phi, y) \propto p(y | \beta, \phi)$
- Proposal: $J_t(\beta^{*}) \propto \text{N}(\beta^{*}| \hat{\beta}_{pos}, V_{pos})$

#### b. Random walk Metropolis  
- Posterior: $p(\beta | \phi, y) \propto \text{N}(\beta| \hat{\beta}_{pos}, V_{pos})$ (normal approximation)  
- Proposal: $J_t(\beta^{*} | \beta^{t-1}) \propto \text{N}(\beta^{*}| \beta^{t-1}, (2.38^2/d)V_{pos})$ where $d=2$

#### c. Data augmentation
- Introduce latent variable and gibbs sampling
- Gibbs sampling: If $p(\beta) \propto 1$,  
  1. $\beta | u, y \sim N((X^{T}X)^{-1}X^{T}u, (X^{T}X)^{-1})$
  2. $u_i | \beta, y \sim$ $\begin{cases}
    \text{TN}_{(0, \inf)} (X_i \beta, 1) & y_i = 1 \\
    \text{TN}_{(-\inf, 0)} (X_i \beta, 1) & y_i = 0 \end{cases}$