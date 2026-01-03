## Este script tiene como finalidad, ser la base para el power bi de ProduBot
## tambien por que estoy aburrido XD

## Daniel Rojas Sánchez
## Primero cargamos los paquetes necesarios


using DataFrames
using CSV
using XLSX
using Dates
using Statistics
using StatsBase
using Plots


## summary

path = "C:/Users/Daniel_Rojas/Nadro, S.A.P.I. de C.V/ProduBot - Mejora_continua/2024/CORTES/"
path2 = "Payment Support/base_csv/"
path3 = "C:/Users/Daniel_Rojas/Nadro, S.A.P.I. de C.V/ProduBot - Mejora_continua/2024/CORTES/Proyecto Anual/ProduBot666/Export/"

meses = [
    "1.Enero/", 
    "2.Febrero/", 
    "3.Marzo/", 
    "4.Abril/",
    "5.Mayo/",
    "6.Junio/",
    "7.Julio/",
    "8.Agosto/"
]

###############################################################
###########################################################

summary = []

for mes in  meses
    ruta_archivo = joinpath(path,mes,path2,"7-Summary.xlsx")
    df = DataFrame(XLSX.readtable(ruta_archivo, "Summary"))
    data = push!(summary, df)
end

summary = vcat(summary...) 
CSV.write(joinpath(path3,"1.Summary.csv"), summary)

################################################################
################################################################


RPV = []

for mes in  meses
    ruta_archivo = joinpath(path,mes,path2,"base_rpv_clean.csv")
    df = CSV.read(ruta_archivo, DataFrame)
    data = push!(RPV, df)
end

RPV = vcat(RPV...) 
CSV.write(joinpath(path3,"2.base_rpv.csv"), RPV)

################################################################
################################################################

data_SAP = []

for mes in  meses
    ruta_archivo = joinpath(path,mes,path2,"data_SAP.csv")
    df = CSV.read(ruta_archivo, DataFrame)
    data = push!(data_SAP, df)
end

data_SAP = vcat(data_SAP...) 

## CSV.write(joinpath(path3,"data_SAP"), data_SAP)

### ✌️


condicion =  coalesce.(data_SAP."Hora de confirmación" .>= Time("21:00:00"), false)
data_SAP.Fecha2 = ifelse.(condicion, coalesce.(data_SAP."Fecha confirmación" .+ Day(1), missing), data_SAP."Fecha confirmación")


danielovsky = combine(
    groupby(data_SAP, [:"Fecha2", :"Proceso","TURNO"]) ,
        :"Ctd.real dest.UMB" => sum => :Piezas , 
        :"Volumen de carga" => sum => :Volumen, 
        nrow => :Renglones,
        :"Inicio" => minimum => :Inicio,
        :"Fin" => maximum => :Fin,
        :"Confirmado por" => x -> length(unique(x))
)

## Resumen Procesos


CSV.write(joinpath(path3,"3.data_SAP.csv"), danielovsky)


## DIFS
DIFS = filter(row -> coalesce(row[Symbol("Código de excepción")] == "DIFS", false), data_SAP)
CSV.write(joinpath(path3,"4.DIFS.csv"), DIFS)


## ABC (Obtener los productos con mayor rotacion en el surtido x Area 

ABC = filter(row -> coalesce(row[Symbol("Proceso")] == "Surtido", false), data_SAP)

ABC = combine(
    groupby(ABC, [:"Fecha", :"Producto","Descripción de producto", "Area", "Rack"]) ,
        :"Ctd.real dest.UMB" => sum => :Piezas , 
        :"Volumen de carga" => sum => :Volumen, 
        nrow => :Renglones
)


CSV.write(joinpath(path3,"5.ABC.csv"), ABC)



