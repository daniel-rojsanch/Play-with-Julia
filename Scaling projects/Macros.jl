## The last important feature of the julia languaje are macros
## For our current purposes we will need to use the @time macro to
## compare functions

## So, what does a macro do? Macro are used to generate code of you program
## you can easily recognize macro calls in the code as a macro is always
## prefixed with the @ character .


@time 1 + 1

mi_media(x) = sum(x)/length(x)
x = [1, 4, 6, 1, -9, 1, 5, 2, -6]

## Compapar
using Statistics

@time mean(x)
@time mi_media(x)

using BenchmarkTools
x = rand(10^5)
@benchmark mean(x)
@time mean(x)

@macroexpand @time mean(x)



