# Final project for Advanced Bayesian Methods
**자세한 사항은 같은 폴더 내의 "Final_houseprice.pdf"**

## 1. Data
## 2. EDA
## 3. Model
### Model 1 - Hierarchical Linear model with riverside random effect
#### 1. Model formula
<img width="1034" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/81ce00e3-1f2a-47f3-8db9-2bf836a54770">

#### 2. Model compile (pystan)
#### 3. Fit the model
#### 4. Check the MCMC convergence
#### 5. Poseterior Predictive check (ppcheck); ppp-value
  a. Residual Test quantity
  <img width="1037" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/7eca7dbe-1ae6-48ae-bd74-707feeecb252">

  b. Mean Test quantity
  <img width="1016" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/82442dd3-08ad-4e47-95f7-697e8e3c5a8f">

  c. The square root of the average of the 2 riverside residuals
  <img width="1031" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/74b49e75-2f61-4571-a5ac-7ebe36b6148c">

### Model 2 - Simple Linear model
#### 1. Model formula
<img width="1028" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/854f7cce-3890-45a1-8dda-9b4bd8063e1d">

나머지는 Same as model 1

### Model 3 - Hierarchical Linear model with new_grade random effect
#### 1. Model formula
<img width="1032" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/83b4da98-4edf-4d18-bdb4-0d1bec1fb158">


나머지는 Same as model 2
## Note
**pppvalue**
- pppvalue는 정해진 정답은 없고 모델에 맞는 test quantity를 골라야함. 일반적으로 regression 모델의 경우 residual test quantity를 많기 쓰긴 함.
- **Predictive posterior p value (pppvalue)** is a the tail posterior probability for a statistic generated from the model compared to the statistic observed in the data. Ley $y=(y_1, \dots, y_n)$ be the observed data. Suppose the model has been fit and there is a set of simulation $\theta^{(s)}, s=1, \dots, n_{sims}$. In replicated dataset, $y^{rep (s)}$ has been generated from the predictive distribution of the data, $p(y^{rep (s)} | \theta=\theta^{(s)}$). Then the ensemble of simulated datasets, $(y^{rep (s)}, \dots, y^{rep (n_{sims})})$, is a sample from the posterior predictive distribution, $p(y^{rep} | y)$.  
The model can be tested by means of discrepancy statistics, which are some function of the data and parameters, $T(y, \theta)$. If $\theta$ was known, then compare discrepancy by $T(y^{rep}, \theta)$. The statistical significance is $p=Pr(T(y^{rep}, \theta) > T(y, \theta)|y, \theta)$. If $\theta$ is unknown, then average over the posterior distribution of $\theta$,  
<img width="1026" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/b39e6941-55f9-4328-842b-fc444d2da786">
which is easily estimated from the MCMC samples. The example is residual test quantity as:
<img width="1037" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/7eca7dbe-1ae6-48ae-bd74-707feeecb252">
