using Plots
using Statistics


n = 10^3

x = randn(n, 2)
y = 3*rand(n, 2)
z = ℯ.^(x) .- 3

scatter(x[:,1], x[:,2], c = "red")
scatter!(y[:,1],y[:,2], c = "blue")
scatter!(z[:,1],z[:,2], c = "yellow")

