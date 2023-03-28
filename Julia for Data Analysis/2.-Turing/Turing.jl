## Empezando a usar turing 

using Turing
using StatsPlots

InverseGamma(2,3)


plot(InverseGamma(2,3))
plot!(Normal(2,3))


## Crearemos un modelo normal con parametros desconocidos

@model function d_model(x, y)
    s² ~ InverseGamma(2, 3)
    m ~ Normal(0, sqrt(s²))
    x ~ Normal(m, sqrt(s²))
    return y ~ Normal(m , sqrt(s²))
end


d_model

## Ejecurar una muestra 
## muestrador hamiltoniano Monte Carlo

obs = sample(d_model(1.5,2), NUTS(), 1000)

## esta medio enfermo esto