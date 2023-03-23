## Introducción al Lenguaje de Progrmacióñ Julia
## Daniel Rojas Sánchez

## Según Eintein no entiendes algo hasta que no eres 
## capaz de enseñrselo a tu abuelita

## Con esto en mente quiero aprender julia 
## al mismo tiempo que etrato de enseñarlo a 
## un publico desconocido.

## Como es costumbre, el famoso Hola mundo.

println("Hola Mundo")


## Julia como calculadora

1 + 1
1 - 1 
1/5
4*4

4^2
sqrt(9)

log(ℯ)
log(ℯ^2)

log10(100)

## Trigonometria
π
sin(0)
cos(0)

## Variables en Julia
## podemos guradar valores en Variables

x = 1

## y cambiarlas

x = 2

## Ojo con esto

x = [1, 6, 10]
y = x

## Tambien se cambia de valor y[1]
x[1] = 5
y[1]

## para evitar esto 
y = copy(x)
x[3]
x[3] = -10000
y[3]


## Algo que me gusta de julia es que puedes usar emojis como Variables XD
## o incluso LaTeX

x² = 2
∑i = 100
θ = 5



💀 = "una Calavera"

### Veamos un poco las matrices

mat = [1 3 5 ; 9 5 -20]

## Primer elemento
mat[1,1]

## dimension de la matrix
size(mat)

## Primera columna
mat[:,1]

## primera fila
mat[1,:]












