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



