## Cargamos las Librerias Necesarias
## para trabajar con dataframes 🤖,

using DataFrames
using RDatasets
using CSV
using Plots
## Cargamos un conjunto de datos famoso en R, llamado iris
iris = dataset("datasets","iris")

## Un rapido resumen estadistico de cada variable.
describe(iris) 

## Numero de columnas del dataframe
ncol(iris)
nrow(iris)
## nombre de dataframe
names(iris)

## podemos crear nuestro archivo CSV
CSV.write("iris.csv",iris)

## y leerlo 

data = CSV.read("Book Julia for Data Analysis/Data Frames/iris.csv",DataFrame)
data == iris

## Seleccionar y acceder a un columna 

iris.Species
iris[:, [1,4]]

iris[:, "Species"]
iris[:,:Species]

## Preguntar que numero de columna es
columnindex(iris, "Species")

## Para verificar que exista el nombre una columna
## podemos hacerlo de la siguiente manera

hasproperty(iris, "Species")
hasproperty(iris, "Species99")
hasproperty(iris, :Species)

@time iris.Species
@time iris[:, :Species]


data[!, :Species]

## Visualizar datos almacendos es columnas de un DataFrame
names(iris)

plot(
scatter(iris.SepalLength, iris.SepalWidth, group = iris.Species),
histogram(iris.PetalWidth)
)

1 + 1

###########

df = DataFrame(A = 1:4, B = ["Maria", "Tania", "Diana", "Maria"])

df.A
df.B

df."B"

names(df)
propertynames(df)

#############

dogs = DataFrame(Id = 1:4, Name = ["Zapote", "Paris", "Luna", "Vladimir"], Specie = ["Pator" , "Chihuahua", "Husky", "Husky"])

## Expresion Regular
names(dogs, r"Spe")

## Seleccionar Todas las columnas exepto Id
dogs[:,Not(:Id)]





