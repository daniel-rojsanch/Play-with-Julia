## Matematicas en julia

x = 10
y = 3

# suma
x + y

## resta 
x - y

## division 1

x/y

## division 2
y\x

## division 3
x ÷ y

## multiplicacion

x*y

## exponencial

x ^ y

# residuo
x%y

## residio 2
rem(x, y)

## Boolean

true

false

## Operadores logicos

## Comparar si dos variables son igules

x == y

## y
true & false

## o
true | false

## negacion
!false

x > y

x <= y

## consecutivo
~3

~3456

x 

## otros opradores

x += 3

x

x -= 3

x

x *= 3

## Vectorizar operadores

x = [1, 6, 8, 10]
y = [5, 2, 6, 1]

x .+ 1

x

x .- 10

x .-=10

x

x = [1, 2, 3, 4]

## elevar todos al cuadrado

x.^2

## elevar al cuadrado y sacar la raiz
sqrt.(x.^2)

x

## puses usar la macro @. 

@. x+1

x.^2 .- 10

@. x^2 - 10

x = 1:10

y = x + randn(10)

## redondear
round.(y)

floor(3.8)

floor(3.1)

floor(3.99999)

ceil(3.000001)

ceil(3.5)

ceil(3.99999)

trunc.(y) .== floor.(y)

trunc.(y)

### mas sobre las diciviones

## trunca la division
10 ÷ 3

fld(10, 3)

cld(10,2.2)

10/2.2

## regresa -1 o + 1
sign(-10)

## absoluto

abs(-10)

abs2(-10)

exp(3)

ℯ

ℯ^3

log(ℯ)

y = [-2π, 0, π/2]

sin.(y)


