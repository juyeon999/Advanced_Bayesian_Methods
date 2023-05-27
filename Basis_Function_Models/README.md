# Basis Function Models (Bayesian)
## What is Nonparametric model?
- Parametric linear model
  - $E(y_i) = g(X_i, \beta)$ with known function $g$ (but with unknown $\beta$)
  - unknown $\beta$ is the target of inference
- nonparametric linear model
  - $E(y_i) = \mu(X_i)$ with unknown function $\mu$ (with $\mu$ falls in class of nonlinear functions.)
  - Add gaussian assumption to random noise
  - $y_i = \mu(x_i) + \epsilon_i, \quad \epsilon \sim \text{N}(0, \sigma^2)$
  
### Why we use basis expansion for density estimation?
> basis로 target distribution과 같은 공간 span 할 수 있다면 target distribution도 approximate 가능 (taylor expansion으로 뒷받침 가능)  

- $\mu(x) = \sum_{h=1}^{H} \beta_h b_h(x)$
- Can be expressed as Linear model
- $y = W\beta + \epsilon, \epsilon \sim \text{N}(o, \sigma^2 I_n)$
  - **$W = ((b_h(x_i)))_{i, h} \in R^{n \times H}$** where $H$ is the number of the basis functions 
- Inference is same as the Linear regression.

## Basis fuction
- There are many basis which span same space. 

### 1. Gaussian Radial Basis
### 2. B-Spline Basis
- Piecewise polynomial basis function
### 3. etc
- Truncated power function
- polynomial radial function

## Examples (Implement)
The model is given as   
$$y_i = sin^3(2 \pi x^3_i) + \epsilon_i, \quad \epsilon_i \sim \text{N}(0, 0.1^2), \quad i = 1, \dots, n.$$
Explore a model-averaged estimate of the target function isng B-spline, put $g$-prior on coefficients $\beta_H$ with $g = n$, the Jeffreys prior on $\sigma^2$, and a Possion prior Pois(1) on $L$.  
(Model-average: With predified uniform knots, choose important knots (or basis terms) among the set)  
  
The the result of Bayesian model averaging is  
  
<img width="566" alt="image" src="https://github.com/juyeon999/Advanced_Bayesian_Methods/assets/132811616/f5e9ffca-c1c3-41d7-be9f-8e78c4b23bc8">


### Reference
- Bspline example in python. 
   - https://patsy.readthedocs.io/en/latest/spline-regression.html#general-b-splines
   - https://www.datatechnotes.com/2021/11/b-spline-fitting-example-in-python.html
