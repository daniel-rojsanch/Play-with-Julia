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

# Ejemplo 2

mat = [1 4 1 7; 17 -4 23 3; 0 3 6 -1; 7 7 0 -12]
mat
size(mat)
size(mat, 1)
size(mat,2)

I = mat*inv(mat)
isapprox( I[1,2],0)

mat
mean(mat; dims = 1)
mean(mat;dims = 2)

## Accediendo a elemnetos de una matriz
mat[1,1]
mat[1:4,2]
mat[ : ,2]
mat[2,:]

mat[3:4,3:4]