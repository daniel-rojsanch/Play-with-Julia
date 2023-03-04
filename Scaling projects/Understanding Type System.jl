# A single function in julia may have multiple methods

# --- List of methods for the cd function 

methods(cd)

sum isa Function
typeof(sum)
supertype(typeof(sum))


supertype(typeof(sum)) == Function

## Finding all supertyper of a type 

function arbol_tipos(T)
    println(T)
    T == Any || arbol_tipos(supertype(T))
    return nothing
end

arbol_tipos(Int64)
arbol_tipos(Vector)
arbol_tipos(String)
arbol_tipos(typeof(sum))

### Funciones 

f(x::Int64) = println(x, " Es un entero")
f(1)

# pero si pasamos esto, 

f(1.1)


## otro ejemplo'

h(x::Int8, y::Float64) = return x + y
h(1, 1.0)



