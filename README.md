# Advanced_Bayesian_Methods
Advanced Bayesian Methods (STA9105)

Each file has a theoretical and computational problem about advance bayesian methods.
All analytical derivations are in pdf files and the computational works are contained in ipynb files.

## 1. Bayesian Linear regression 
## 2. Hierarchical Linear models
### 2-1. Model outline
- The mixed linear model (=hierarchical linear model) with multidimensional random effects
  - Let $y_j \in \mathbb{R^{n^j}}$ and $X_j \in \mathbb{R^{n_j \times d}}$ be the observation vector and the design matrix for subject $j = 1, \dots, m$, respectively. Using subject-specific random effects $\beta_j \in \mathbb{R}^d$, we can write a mixed effect model as
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/2daf7253-13af-4f6d-874c-5fc4da2d3834)

### 2-2. Drive conditional posterior
- Full derivation is describe in 'Solution for analytical questions.pdf'

### 2-3. Gibbs sampling and posterior check
#### a. prior
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/3e068e25-0e76-4edb-884f-52c921e5fe3a)

   
#### b. full conditional distribution
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/4688a5db-2b58-4f59-91dd-a94eeef777f2)


#### c. Posterior predictive check
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/925367be-e00d-434c-969a-20903f7f9265)

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
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/14a66407-6b0a-4bfe-9de8-e037230950b9)


### 3-3. Methods to obtain posterior distribution of $\beta$

#### a. Independent Metropolis-Hastings 
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/82a6d734-6c91-4f55-93f0-a2438d2dfb84)

#### b. Random walk Metropolis  
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/ca33b25c-6a3b-45bd-8e2a-2f52e8fcd25b)

#### c. Data augmentation
![image](https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/4064871a-da2d-4ffd-9872-8985718a044c)
