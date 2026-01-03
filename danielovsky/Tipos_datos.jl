## Vamos Crear algunas variables

## Entero

x = 3
typeof(x)

## Flotante

y = 4.4
typeof(y)

## Cadena

z = "Hola GitHub"
typeof(z)


## Crear una funcion que reciba un numero
## devuelva "positivo", "Negativo" "cero"

n = 5

eva = function (x)
    if x < 0
        print("Negativo")
        
    end
    if x > 0
        print("Positivo")
    end
    if x == 0
        print("cero")
    end
end


eva(6)
eva(-4)
eva(0)

## Otra Forma

function eva_2(x)
    if x < 0 
        "Negativo"
    elseif x > 0 
        "Positivo"
    else
        "Cero"
    end
end

eva_2(6)
eva_2(-4)
eva_2(0)

## Otra Forma "Compacta"

eva_3(x) = x < 0 ? "Negativo" : x > 0 ? "Positivo" : "Cero"

eva_3(6)
eva_3(-4)
eva_3(0)

## Otra forma "JULIANA"
## sign(x)

sign(6)
sign(-4)
sign(0)

eva_4(x) = sign(x) == 1 ? "Positivo" : sign(x) == -1 ? "Negativo" : "Cero"

eva_4(6)
eva_4(-4)
eva_4(0)

## Tenemos varias funciones que hacen lo mismo
## usamos BenchmarkTools para comparar

using Pkg
Pkg.add("BenchmarkTools")

using BenchmarkTools

@btime eva_2(10)
@btime eva_3(10)
@btime eva_4(10)


@benchmark eva_2(10)
@benchmark eva_3(10)
@benchmark eva_4(10)