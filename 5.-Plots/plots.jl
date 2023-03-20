using Plots
using RDatasets

## Usamos el conjunto de datos mas famosos en RDatasets

iris = dataset("datasets", "iris")
x = iris.SepalWidth
y = iris.SepalLength

### Basis

a = scatter([1, 3, 5], [1, 2, 10])
b = histogram(iris.SepalLength)
plot(a, b)

## usar plot para crear un nuevo
## usar plot! para agregar a uno existete

## ejemplo 1
plot()
scatter!([1, 4, 5],[10, 2, 1])

## ejemplo 2
scatter(randn(100), randn(100)) ## Normal

## ejemplo 3
plot([sin, cos], -2π, 2π)
title!("Seno y Coseno")

## ejemplo 4
histogram(iris.SepalLength, color = "red",
title = "histograma de Sepal Length")


## ejemplo 5 : Trigonometria

f3(x) = sin(x)^2 - 1/2
plot([sin, cos, f3], -2π, 2π, lw = [1 2 3], label = ["sin" "cos" "f3"])

## Ejemplo de la pagina

x = range(0, 10, length=100)
y1 = sin.(x)
y2 = cos.(x)
y3 = @. sin(x)^2 - 1/2

plot(x, [y1 y2], label=["sin(x)" "cos(x)"], lw=[2 1])
plot!(x, y3, label="sin(x)^2 - 1/2", lw=3, ls=:dot)
plot!(legend=:outerbottom, legendcolumns=3)
xlims!(0, 2pi)
title!("Trigonometric functions")
xlabel!("x")
ylabel!("y")
