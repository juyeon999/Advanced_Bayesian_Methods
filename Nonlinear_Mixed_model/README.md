# Nonlinear Mixed model - parametric model

## Data
The orange data of Draper and Smit (1981), which is available in R with the object name `Orange`.  

## Model
$$y_{ij} = \frac{\beta_1 + u_i}{1 + \text{exp} \{-(AGE_{ij} - \beta_2) / \beta_3\}} + \epsilon_{ij}, \quad u_i \sim \text{N}(0,\tau^2), \quad \epsilon_{ij}  \sim \text{N}(0, \sigma^2)$$

## Prior
Based on EDA, the between-group variability looks strong. Therefore, give informative prior to $\tau^2$ and noninformative prior to the others.
$$\tau^2 \sim \text{Inv-Gamma}(3, 0.5), \quad \beta \sim \text{MVN}(0, 1000 I_3) \, \text{and} \sigma^2 \sim \text{Inv-Gamma}(0.01, 0.01)$$

## Result
(In pdf file)
