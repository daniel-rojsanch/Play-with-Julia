## import vs using
import Statistics

x = [1, 2, 3]

## Nos da un error
mean(x)

## Pero si usamos 
Statistics.mean(x)

## Otra opcion es usar 

using Statistics
mean(x)


## Tidier

using Tidier
x = [1, 2, 3, 5]
|>

using StatsBase

winsor
x = [-100, 3, 5, 7, 10000]
mean(x)
mean(winsor(x, count  = 1))






