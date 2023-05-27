## likelihood
$p(y | \beta_H, \sigma^2, H) \sim N_H \left(W_H \beta_H, \sigma^2 I_n \right)$

## Prior
1. $p(\sigma^2) \propto (\sigma^2)^{-1}$ 
2. $p(H) = p(L) \sim Pois(1)$
3. $\beta_H | \sigma^2, H \sim N_H \left(0, g\sigma^2 (W_H^T W_H)^{-1} \right)$ (g-prior)

## Posterior
1. $p(\beta_H | \sigma^2, H, y) \sim N_H \left(\frac{g}{1+g}(W_H^{T}W_H)^{-1}W_H^{T}y, \frac{g\sigma^2}{1+g}(W_H^T W_H)^{-1} \right)$
2. $p(\sigma^2 | H, y) \sim Inv-Gamma\left( \frac{n+1}{2}, \frac{1}{2}y^T (I_n - \frac{g}{g+1} W_H(W_h^T W_H)^{-1}W_H^T)y \right)$
3. $p(H | y) \propto p(H) \{\frac{1}{2}y^T (I_n - \frac{g}{g+1} W_H(W_h^T W_H)^{-1}W_H^T)y \}^{-\frac{n+1}{2}}$

---
### 1. $p(\beta_H | \sigma^2, H, y)$
$$
\begin{align*}
p(\beta_H | \sigma^2, H, y) &\propto p(y, \beta_H | \sigma^2, H) \\
&= p(y | \beta_H, \sigma^2, H)p(\beta_H | \sigma^2, H) \\
&= N_H \left(W_H \beta_H, \sigma^2 I_n \right) \times N_H \left(0, g\sigma^2 (W_H^T W_H)^{-1} \right) \\
& = (\sigma^2)^{-n/2} |g\sigma^2 (W_H^T W_H)^{-1}|^{-1/2} \times
exp \left( -\frac{1}{2} \{(y-W_H\beta_H)^{T}\frac{1}{\sigma^2}  (y-W_H\beta_H) + \beta_H^{T} (\frac{1}{g\sigma^2}W_H^T W_H) \beta_H \} \right) \\
& \propto exp \left( -\frac{1}{2\sigma^2} \{(y-W_H\beta_H)^{T}  (y-W_H\beta_H) + \beta_H^{T} (\frac{1}{g\sigma^2}W_H^T W_H) \beta_H \} \right) \\

& = exp\left( -\frac{1}{2\sigma^2}\{\beta_H^{T} (W_H^{T} W_H + \frac{1}{g}W_H^T W_H)\beta_H+ 2(y^{T}W_H)\beta_H + y^{T}y \} \right)\\

& \propto exp\left( -\frac{1}{2}( \beta_H - \mu_{\beta})^{T} \Sigma_{\beta}^{-1} (\beta_H - \mu_{\beta}) \right) \quad (\text{for some } \mu_{\beta}, \, \Sigma_{\beta}) \\

\end{align*} 
$$

For Some $\mu_{\beta}, \, \Sigma_{\beta}$,
$$
\begin{align*}
&\Sigma_{\beta} = \frac{1}{\sigma^2}(W_H^{T} W_H + \frac{1}{g}W_H^T W_H)^{-1}, \,\,
\mu_{\beta}^{T}\Sigma_{\beta}^{-1} = \frac{1}{\sigma^2}y^{T}W_H\\
\therefore \, \, &\Sigma_{\beta} = \frac{g\sigma^2}{1+g}(W_H^T W_H)^{-1}, \,\,
\mu_{\beta} = \frac{g}{1+g}(W_H^{T}W_H)^{-1}W_H^{T}y
\end{align*}
$$
Therefore,
$p(\beta_H | \sigma^2, H, y) \sim N_H \left(\frac{g}{1+g}(W_H^{T}W_H)^{-1}W_H^{T}y, \frac{g\sigma^2}{1+g}(W_H^T W_H)^{-1} \right)$

---
### 2. $p(\sigma^2 | H, y)$
$$
\begin{align*}

p(\sigma^2 | H, y) &\propto p(y, \sigma^2 | H) \\
&= \int p(y, \beta_H,  \sigma^2 | H)d\beta_H \\ 
&= \int p(y| \beta_H,  \sigma^2, H) p(\beta_H | \sigma^2, H) p(\sigma^2) d\beta_H \\ 
&\propto (\sigma^2)^{-1} \int p(y| \beta_H,  \sigma^2, H) p(\beta_H | \sigma^2, H) d\beta_H \\

&= (\sigma^2)^{-1} \int N_H \left(W_H \beta_H, \sigma^2 I_n \right) \times N_H \left(0, g\sigma^2 (W_H^T W_H)^{-1} \right) d\beta_H\\
& = (\sigma^2)^{-n/2-1} |g\sigma^2 (W_H^T W_H)^{-1}|^{-1/2} \times
\int exp\left( -\frac{1}{2\sigma^2} \{\beta_H^{T} (W_H^{T} W_H + \frac{1}{g}W_H^T W_H)\beta_H+ 2(y^{T}W_H)\beta_H + y^{T}y \} \right) d\beta_H\\
& \propto (\sigma^2)^{-(n+1)/2-1} \int exp\left( -\frac{1}{2\sigma^2} \{\beta_H^{T} (W_H^{T} W_H + \frac{1}{g}W_H^T W_H)\beta_H+ 2(y^{T}W_H)\beta_H + y^{T}y +A \} \right) exp(\frac{1}{2\sigma^2}A)d\beta_H \quad (\text{for some } A)\\
&=  (\sigma^2)^{-(n+1)/2-1}exp \left(-\frac{1}{\sigma^2} \left[ \frac{1}{2}y^T (I_n - \frac{g}{g+1} W_H(W_h^T W_H)^{-1}W_H^T)y \right] \right) \\
&\sim Inv-Gamma\left( \frac{n+1}{2}, \frac{1}{2}y^T (I_n - \frac{g}{g+1} W_H(W_h^T W_H)^{-1}W_H^T)y \right)
\end{align*}
$$

Since $\beta_H | \sigma^2, H, y \sim N_H \left(\frac{g}{1+g}(W_H^{T}W_H)^{-1}W_H^{T}y, \frac{g\sigma^2}{1+g}(W_H^T W_H)^{-1} \right)$, we can find $A$ such that 
$\frac{1}{\sigma^2}y^Ty + \frac{1}{\sigma^2}A = \mu_{\beta}\Sigma_{\beta}^T \mu_{\beta}$. And $A$ is
$$
\begin{align*}
A &= \sigma^2 \mu_{\beta}\Sigma_{\beta}^T \mu_{\beta} - y^Ty  \quad \\
&= y^T \frac{g}{g+1} W_H (W_h^T W_H)^{-1} W_H^T y - y^Ty \\
&= y^T (\frac{g}{g+1} W_H(W_h^T W_H)^{-1}W_H^T - I_n)y
\end{align*}
$$

---
### 3. $p(H | y)$
$$
\begin{align*}
p(H | y) & \propto p(H)p(y|H) \\
&= p(H)\int\int{p(y| \beta_H,  \sigma^2, H) p(\beta_H | \sigma^2, H) p(\sigma^2)} d\beta_H d\sigma^2 \\
&= p(H) \int{(\sigma^2)^{-(n+1)/2-1}exp \left(-\frac{1}{\sigma^2} \left[ \frac{1}{2}y^T (I_n - \frac{g}{g+1} W_H(W_h^T W_H)^{-1}W_H^T)y \right] \right)} d\sigma^2 \\
&=p(H) \{\frac{1}{2}y^T (I_n - \frac{g}{g+1} W_H(W_h^T W_H)^{-1}W_H^T)y \}^{-\frac{n+1}{2}}
\end{align*}
$$
---