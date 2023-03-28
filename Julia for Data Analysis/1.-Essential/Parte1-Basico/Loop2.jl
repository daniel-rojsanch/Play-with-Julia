## Expresiones compuestas
## 🔎En ocaciones es nesesario hacer varias operaciones 
## pero agrupadas, veamos un ejemplo

x = -7
x < 0 && begin
    println(x)
    x += 1
    println(x)
    2x
end

# --------🔑
x > 0 ? (println(x);x) : (x += 1; println(x); x)

