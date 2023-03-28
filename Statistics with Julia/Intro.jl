## Random Numbers and MonteCarlo Simulation
## Many of the code examples make use of pseudorandom number generation
## the main player in this discussion is the rand()  function


## random number in the interval [0,1]
rand()

## plot 
using Plots
x = rand(5000,2);
scatter(x[:,1],x[:,2])
histogram(x[:,1], bins = 20)

## one may ask why use random or pseudorandom number?
## In the contex of scientific computing and statistics.

f(x, y) = x^2 + y^2 

a = map(f, x[:,1],x[:,2])
a[1] == f(x[1,1],x[1,2])

a .< 1

scatter(x[a .< 1, 1],x[a .< 1, 2])
scatter!(x[a .> 1, 1],x[a .> 1, 2], col = "red")
title!("Uniform Random x² + y² < 1")

## Podemos Calcular un aproximado de pi, con nuestras 5000 obs
n = length(x[a .<1 , 1])
pi_aprox = 4*(n/5000)



