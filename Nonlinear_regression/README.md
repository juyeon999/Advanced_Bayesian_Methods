# Nonlinear Regression

### Stan model reference
- Simple linear regression  
  https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started-(%ED%95%9C%EA%B5%AD%EC%96%B4)


## Posterior predictive p-value
(1) Generate $y^{rep}$ from the posterior predictive distribution.
  * $y^{rep}$ is random samples using posterior samples. 많이 만든 다음에 mean하면 prediction
(2) Compare $y^{obs}$ with $y^{rep}$

## Tips for `Stan`
- `normal` 함수의 두번째 인자는 분산이 아니라 표준편차이다. 
  - In Stan, the second argument to the “normal” function is the standard deviation (i.e., the scale), not the variance (as in Bayesian Data Analysis)
and not the inverse-variance (i.e., precision) (as in BUGS). Thus a normal with mean 1 and standard deviation 2 is normal(1,2), not normal(1,4) or normal(1,0.25)  .
Similarly, the second argument to the “multivariate normal” function is the covariance matrix and not the inverse covariance matrix (i.e., the precision matrix) (as in BUGS). The same is true for the “multivariate student” distribution.  
https://mc-stan.org/docs/2_18/stan-users-guide/some-differences-in-the-modeling-languages.html





