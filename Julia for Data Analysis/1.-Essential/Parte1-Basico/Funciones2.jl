## short version

times_two(x) = 2x
times_two(4)


compose(x, y = 10) = x*y
compose(1)
compose(1, 5)

## map function

x = [1, 5, 8]
map(times_two, x)

times_two.(x)


## anonymus function
map(x -> 2x, [1, 2, 8])

# --- mas de un argumento
map((x, y) -> x + y, [1, 2], [3, 5])


##  function on function

a = [1, 2, 3]
sum(a)

sum(map(x -> x^2, a))
sum(x -> x^2, a)      # hay funciones que podemos omitir el map

sum(a) do x
    println("procesando ", x)
    return x^2
end


## do

x = [1, 2, 4, 6]

function me(x)
    sum(x)/length(x)
end

me(x)

media(x) = sum(x)/length(x)
media(x)

## varianza = E(x^2 ) - E(x)^2

using Statistics

# -------Sacar Varianza y esperanza 
x_obs = [1, 3, -7, 10, 2]
mean(x_obs)
var(x_obs)

## crear una funcion para obtener esperanza

mi_media(x) = sum(x)/length(x)
mi_media(x_obs) == mean(x_obs)


# -------------------------
m = mi_media(x_obs)
vari(v) = sum((v .- m).^2)/(length(v) - 1)
vari(x_obs)