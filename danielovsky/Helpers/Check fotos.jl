
## Script para detectar que fotos me faltan

using XLSX
using DataFrames
using CSV

folder_git = "C:/Users/Daniel_Rojas/OneDrive - Nadro, S.A.P.I. de C.V/user-photos/Photos"
files = readdir(folder_git)

## Filtrar solo los que terminen con .jpg
fotos = filter(x -> endswith(x, ".jpg"), files)
fotos = first.(fotos, 6)
x = DataFrame(Empleado = fotos)


## Vamos a ller nuestro lista de empleados
file_fotos = "C:/Users/Daniel_Rojas/Nadro, S.A.P.I. de C.V/ProduBot - Mejora_Continua/2024/CORTES/Proyecto Anual/ProduBot666/Fotos.xlsx"
empleados = DataFrame(XLSX.readtable(file_fotos, "Fotos"))
empleados.Empleado = string.(empleados.Empleado)

faltantes = setdiff(empleados.Empleado, x.Empleado)
ubi_foto = DataFrame(Empleados = faltantes)
CSV.write("C:/Users/Daniel_Rojas/Nadro, S.A.P.I. de C.V/ProduBot - Mejora_Continua/2024/CORTES/Proyecto Anual/ProduBot666/Faltan.csv", ubi_foto)