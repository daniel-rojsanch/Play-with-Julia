## Calculadora de sigma

using Distributions
using DataFrames
using XLSX
using CSV

σ(x) = cdf(Normal(0,1), x) - cdf(Normal(0,1), -x) 

sigma = 0:.1:6

p = []
p = map(σ, sigma)

data = DataFrame(Nivel_sigma = sigma, efectividad = p)

CSV.write("C..../sigma.csv", data)