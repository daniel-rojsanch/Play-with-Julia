## Ejemplo de regression lineal simple con Julia
## y = a + mx


## Cargar Librerias
using Plots
using Statistics

## Crear variables pseudoaleatorias Y~x para ver como funciona un regresin

a = 3
m = 1/5
x = rand(1:100, 200)
y = a .+ b.*x .+ 5*randn(200) 



## Parametros estimados

m̂ = sum( (x .- mean(x)).*(y .- mean(y)) ) / sum((x .- mean(x)).^2)
â = mean(y) - m̂*mean(x)


## graficar y ~x
scatter(x, y, label = "data")
plot!(x, â .+ m̂.*x, lw = 4,label = "Parametros estimados")
title!("Regresion Lineal Simple")

savefig("regre.svg")
