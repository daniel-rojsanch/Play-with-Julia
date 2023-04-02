using Plots
gr()
y3(θ) = @. sin(2θ)^2 - 1/2

plot([sin, cos], -2π, 2π, label = ["seno" "coseno"], lw = [2 4])
title!("Coseno vs Seno ")

## Guardar una imagen
# png("img/fig_2.png")

x = -2π:0.1:2π
n = length(x)
y = sin.(x) + 0.1randn(n)

plot(x, sin, label = "Seno")
scatter!(x, y, label = "Data")
title!("Seno ")
plot!(legend=:topright)

### Histograma
using LaTeXStrings
x = randn(1000)
histogram(x, color = "red", label = "x ∼ Normal")
title!("Histograma X ∼ N(μ = 0, σ = 1)")



