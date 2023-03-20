# Matriz de 2 x 3
m = [1  6   7 ; 4  7   -1]

# conociendo las dimenciones
size(m)
# filas
size(m, 1)
# columnas
size(m, 2)

## Tuples
## before we move forward lets us  briefly discuss what a tuple is.
## tuples are ummutable

t = (1, 2, 3)
t[1]
## error
# t[1] = 10

## Computing basic statistics of the data stored in a matrix

using Statistics
mean(m; dims = 2)
std(m; dims = 1)


