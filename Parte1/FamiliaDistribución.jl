## Probability Distributions
## Daniel Rojas Sanchez

## Cargamos paquetes 
using Plots

## crear 2 muestra pseudo-aleatorias tamaño 1000 que se distribuye como una normal 0,1
x = randn(1000);
y = randn(1000);

histogram(x, color = "orange")

scatter(x, y)


