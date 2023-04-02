## Suma de los primeros n nuemros naturales 
## gauss n(n+1)/2


function sum_n(n)
    s = 0
    for i in 1:n
        s += i
    end
    return s
end

sum_n(5)

@time sum_n(1000000)

1_000 == 1000
1_000_000 == 1000000

## Summary 

## - Julia is fast
## - Julia is a modern programing lenguaje
## - Julia is expressive and easy to use
## - Julia is fun


