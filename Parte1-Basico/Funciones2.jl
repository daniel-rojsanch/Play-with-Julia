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


