x = 1:10
for i in x
    print(i)
end

# ----- Algo mas interesante

for i in x
    isodd(i) ? println(i, " es impar\n") : print(i," es par\n")
end

# --- 

x = [1, -2, 5]

for i in x
    println(i > 0 ? "positivo" : "Negativo")
end

# ---- While

i = 1
while i < 4
    println(i, " es", isodd(i) ? " odd" :  " even")
    global i += 1
end


# ----- 

a = [1, 3, 4]
b = a

a[1] = 10
b[1]

c = copy(b)
b[1] = 1

c[1]

## Continuamos con los Loops

# --- Continue and break

x = 1
x < 0 && println("Hola")


i = 0 

while true
    global i += 1
    i > 10 && break
    isodd(i) && continue
    println(i, " es par")
end