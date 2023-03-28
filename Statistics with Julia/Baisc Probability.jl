# 🎲 wish to find the probability that the sum of the outcomes of the dice is even 
# 🎲 + 🎲

p = 18/36 ## True probability

## Simulation
n = 10^3
dado = 1:6
p = sum([iseven(i + j) for i in dado , j in dado])/length(dado)^2


x_obs = rand(dado, n, 2)
p_est = sum(iseven.(cumsum(x_obs, dims = 2)[:,2]))/n

using Plots
using StatsBase
bar(countmap(x_obs[:, 1]), c = "orange")
title!("Lanzamientos de n Datos")

scatter(x_obs[:,1], x_obs[:,2])


 


