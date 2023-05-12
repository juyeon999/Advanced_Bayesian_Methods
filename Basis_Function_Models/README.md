# Basis Function Models (Bayesian)
## Nonparametric bayesian model
- Parametric linear model
  - $E(y_i) = g(X_i, \beta)$ with known function $g$ (but with unknown $\beta$)
  - unknown $\beta$ is the target of inference
- nonparametric linear model
  - $E(y_i) = \mu(X_i)$ with unknown function $\mu$ (with $\mu$ falls in class of nonlinear functions.)
  - Add gaussian assumption to random noise
  - $y_i = \mu(x_i) + \epsilon_i, \quad \epsilon \sim \text{N}(0, \sigma^2)$
  
### Basis expansion models
- $\mu(x) = \sum_{h=1}^{H} \beta_h b_h(x)$
- Can be expressed as Linear model
- $y = W\beta + \epsilon, \epsilon \sim \text{N}(o, \sigma^2 I_n)$
  - **$W = ((b_h(x_i)))_{i, h} \in R^{n \times H}$** where $H$ is the number of the basis functions 
- Inference is same as the Linear regression.

### Basis fuction
- There are many basis which span same space. 

#### 1. Gaussian Radial Basis
#### 2. B-Spline Basis
- Piecewise polynomial basis function
#### 3. etc
- Truncated power function
- polynomial radial function


### Gaussian process regression


### Reference
- Bspline example in python. 
   - https://patsy.readthedocs.io/en/latest/spline-regression.html#general-b-splines
   - https://www.datatechnotes.com/2021/11/b-spline-fitting-example-in-python.html
