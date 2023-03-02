x = 1:10
for i in x
    print(i)
end

# ----- Algo mas interesante

for i in x
    isodd(i) ? println(i, " es impar\n") : print(i," es par\n")
end