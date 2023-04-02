## 
using Statistics

x_obs = [2, 5, 7, 1, 5]
mean(x_obs)
var(x_obs)

d_mean(x) = sum(x)/length(x)
d_var(x) = sum((x .- d_mean(x)).^2)/(length(x) - 1)

d_mean(x_obs)
d_var(x_obs)

