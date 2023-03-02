## Veamos algunas ejemplos de logica

x = 1
x > 0

## ejemplo 2
x > 0 && print("Paso 2")

## ejemplo 3, Observemos como julia solo evaluo la primera condicion.

x = -1
x < 0 || log(x) > 10

## Ejemplo 4

x = 1
x > 0 && print("x es positivo")

## es como si escribieramos

if x > 0
    print("x es positivo")
end

## Ejemplo 5, similar 

x = -1
x > 0 || print("x es negativo") 

## puede entenderso como 

if !(x > 0 )
    print("x es negativo")
end

#----------------------

x = 0
-1 < x < 1

## Saber si un numero es par o impar

x = 3
isodd(x) && print("x es impar")

x = 2
isodd(x) || print("x es par")

## Ternary Operator

x = 100
x > 0 ? sqrt(x) : sqrt(-x)

## equivale a 

if x > 0 
    sqrt(x)
else
    sqrt(-x)
end

# ---- Con esto queda claro

x  = 1
x > 0 ? println(x," es positivo") : println(x, "es negativo")


