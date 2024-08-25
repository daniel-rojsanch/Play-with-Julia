## Script de julia
## para el calculo de RPV 
## daniel666

## Cargamos las librarias necesarias 


using XLSX
using DataFrames
using CSV
using StatsBase
using Dates

## Aqui pones el nombre de Usuario
## Daniel_Rojas, Juan_Noriega, Orlando_Nunez
## Alinne Zaldivar Olvera, Americo Vespucio


###############################################
##
##                     %%%%
##                    %%%%%%%
##                   #  0--0 #
##                  ##   ||   ##
##                 ##  --v---- ##
##                    %     %
##                      %%%%
##               Daniel Rojas Sánchez
################################################


path = "C:/Users/Usuario/Nadro, S.A.P.I. de C.V/ProduBot - Mejora_Continua/2024/CORTES/8.Agosto"
ruta_base_asistencia = joinpath(path,"Payment Support/1.Base de Asistencia.xlsx")
base_asistencia = DataFrame(XLSX.readtable(ruta_base_asistencia, "Asistencia"))

# raw_data, colnames = XLSX.readtable(ruta_base_asistencia, "Asistencia")
# base_asistencia = DataFrame(raw_data, Symbol.(colnames))

base_empleados = base_asistencia[:,["Empleado", "Fecha de Ingreso", "NOMBRE", "SUPERVISOR", "TURNO", "Centro"]]
base_empleados."Confirmado por" = string.("AL", base_empleados."Empleado" )

folder = joinpath(path,"Bases Sap/SAP PRODUCCION")
vol_file = joinpath(path,"Bases Sap/SAP INVENTARIO/VOL.XLSX")
WT_folder = joinpath(path,"Bases Sap/SAP INVENTARIO/Tareas/")
WO_folder = joinpath(path,"Bases Sap/SAP INVENTARIO/Orden/")
dir_rrrp = joinpath(path,"Payment Support/2.RPV Manual RRRP2.xlsx" )
dir_3pl =  joinpath(path, "Payment Support/3.RPV 3PL Manual.xlsx")

files = readdir(folder)
data = []

for file in files
    ruta_archivo = joinpath(folder, file)
    df = DataFrame(XLSX.readtable(ruta_archivo, "Sheet1"))
    push!(data, df)
end 

data_SAP = vcat(data...)

# "Fecha confirmación" "Hora de confirmación"  "Fe.inicio" "Hora inicio"  "Denomin.tipo proceso almacén"  "Cola" "Confirmado por" 
# "Ubic.procedencia" "Ubicación de destino" "Ctd.real dest.UMB"
# "Código de excepción" "Itinerario" "Volumen de carga" "Tp.ubic.destino"
# procesos = ["Entrada en stock","Salida de almacén","Contabilización de entrada de mercancías","Movimiento de almacén interno"]

Acomodo = filter(row -> row["Denomin.tipo proceso almacén"] == "Entrada en stock" && row["Tp.ubic.destino"] == "B" && row["Ubicación de destino"] ∉ ["GR", "GL"], data_SAP)
Acomodo."Ubic.procedencia" .= ""
Acomodo.Proceso .= "Acomodo"
Acomodo = filter(row -> !startswith(row."Ubicación de destino", "DP"), Acomodo )

Surtido = filter(row -> row["Denomin.tipo proceso almacén"] == "Salida de almacén" && row["Tp.ubic.destino"] == "R" && row["Cola"] ∉ ["DEVOLUCION"] , data_SAP )
Surtido."Ubicación de destino" .= ""
Surtido.Proceso .= "Surtido"

Recibo = filter(row -> row["Denomin.tipo proceso almacén"] == "Contabilización de entrada de mercancías" && row["Tp.ubic.destino"] == "B", data_SAP )
Recibo.Proceso .= "Recibo"

Compactacion = filter(row -> !ismissing(row["Cola"]) && startswith(row["Cola"], "COMPACTA") && row["Tp.ubic.destino"] == "R", data_SAP)
Compactacion.Proceso .= "Compactación"

Reabasto = filter(row -> !ismissing(row["Cola"]) && startswith(row["Cola"], "RPL") && row["Tp.ubic.destino"] == "R", data_SAP)
Reabasto.Proceso .= "Reabasto"


data_sap = vcat(Acomodo, Surtido, Recibo, Compactacion)
data_sap.Inicio = data_sap."Fe.inicio" + data_sap."Hora inicio"
data_sap.Fin = data_sap."Fecha confirmación" + data_sap."Hora de confirmación"

data_sap.Tiempo = (data_sap.Fin - data_sap.Inicio) ./ Hour(1)

## Separar NC Y FC en altas y bajas
data_sap.Ubicación .= ifelse.((data_sap.Proceso .== "Recibo") .| (data_sap.Proceso .== "Reabasto") .| (data_sap.Proceso .== "Compactación") , "00", string.(data_sap."Ubic.procedencia", data_sap."Ubicación de destino"))
data_sap.Rack = first.(string.(data_sap.Ubicación) ,2)

data_sap.Nivel = parse.(Int,last.(data_sap.Ubicación ,2))

data_sap.Nivel_name = ifelse.(data_sap.Nivel .>= 40, "ALTA", "BAJA")
data_sap.Nivel_name2 = ifelse.((data_sap.Rack .== "FC") .| (data_sap.Rack .== "NC" ) .| (data_sap.Rack .== "BB" ) .| (data_sap.Rack .== "BR" ) .| (data_sap.Rack .== "CR" ) .| (data_sap.Rack .== "NP" ) , data_sap.Nivel_name, "" )
data_sap.Area = ifelse.( (data_sap.Proceso .== "Recibo") .| (data_sap.Proceso .== "Reabasto") .| (data_sap.Proceso .== "Compactación"), "Unica", string.(data_sap.Rack, data_sap.Nivel_name2))

data_sap = leftjoin(data_sap, base_empleados , on =:"Confirmado por")
condicion = coalesce.(data_sap.TURNO .== "Nocturno", false) .& coalesce.(data_sap."Hora de confirmación" .>= Time("21:00:00"), false)
data_sap.Fecha = ifelse.(condicion, coalesce.(data_sap."Fecha confirmación" .+ Day(1), missing), data_sap."Fecha confirmación")


data_sap.Fin = string.(Dates.format.(data_sap.Fin, "yyyy-mm-dd HH:MM:SS"))
data_sap.Inicio = string.(Dates.format.(data_sap.Inicio, "yyyy-mm-dd HH:MM:SS"))

CSV.write(joinpath(path,"Payment Support/base_csv/data_SAP.csv"), data_sap)
CSV.write(joinpath(path,"Payment Support/base_csv/data_SAP_Reabasto.csv"), Reabasto)



# 👍 Ya tengo mi base de  las tareas, de acomodo, surtido, recibo, compactacion y Reabasto

## 👽INVENTARIO

vol = DataFrame(XLSX.readtable(vol_file, "Sheet1"))

# row_data, colnames = XLSX.readtable(vol_file, "Sheet1")
# vol = DataFrame(row_data, Symbol.(colnames))

files_wt = readdir(WT_folder)

data = []

for file in files_wt
    ruta_archivo = joinpath(WT_folder, file)
    # row_data, colnames = XLSX.readtable(ruta_archivo, "Sheet1")
    # df = DataFrame(row_data, Symbol.(colnames))
    df = DataFrame(XLSX.readtable(ruta_archivo, "Sheet1" ))
    push!(data, df)
end

data_inv_wt = vcat(data...);

data_inv_wt = filter(row -> row["Status de inventario"] ∉ ["ACTI", "DELE"], data_inv_wt)
#################################################################

files_wo = readdir(WO_folder)
data = []


for file in files_wo
    ruta_archivo = joinpath(WO_folder, file)
    # row_data, colnames = XLSX.readtable(ruta_archivo, "Sheet1")
    # df = DataFrame(row_data, Symbol.(colnames))
    df = DataFrame(XLSX.readtable(ruta_archivo,"Sheet1" ))
    push!(data, df)
end


data_inv_wO = vcat(data...)

#################################################################

data_inv_wt.UbicacionFisica = first.(string.(data_inv_wt.Ubicación),2)
data_inv_wt.Area = string.( data_inv_wt.UbicacionFisica , data_inv_wt."Tipo almacén")
data_inv_wt = innerjoin(data_inv_wt, vol, on =:Producto, matchmissing=:equal)

data_inv_wt.volumencm3 = data_inv_wt."Cantidad contada" .* data_inv_wt.Volumen


## WO  "Orden de almacén" "Fe.inicio"  "Hora inicio" "Confirmado por" "Fecha confirmación" "Hora de confirmación"  "Tiempo real ejec." 
## WT  "Hora de recuento" "Contador" "Tipo almacén" "Ubicación" "Producto" "Orden de almacén" "Tarea de almacén" "Cantidad contada" "Area" "volumencm3"

## Necesitamos saber cuantas tareas tiene cada orden y dividir para darla la parte proporcinal

wo_ctd = countmap(data_inv_wt."Orden de almacén")
wo_ = collect(keys(wo_ctd))

wo_values = collect(values(wo_ctd))
Freq_Ordenes = DataFrame( Orden_Almacen = wo_, Tareas = wo_values )

## Agrgar el Inicio y Fin
data_inv_wO.Inicio = data_inv_wO."Fe.inicio" +  data_inv_wO."Hora inicio" 
data_inv_wO.Fin = data_inv_wO."Fecha confirmación" +  data_inv_wO."Hora de confirmación"

rename!(data_inv_wO, Symbol("Orden de almacén") => :Orden_Almacen) 


paso1 = data_inv_wO[:,["Orden_Almacen", "Tiempo real ejec.","Fecha confirmación", "Hora de confirmación","Inicio", "Fin"]]
paso2 = innerjoin(paso1, Freq_Ordenes, on = "Orden_Almacen", matchmissing=:equal)
Inventario = data_inv_wt[:,["Orden de almacén","Contador", "Cantidad contada", "Area", "volumencm3"]]


rename!(Inventario, Symbol("Orden de almacén") => :Orden_Almacen)

Inventario = innerjoin(Inventario, paso2, on = "Orden_Almacen", matchmissing =:equal)
Inventario.Tiempo = (Inventario."Tiempo real ejec." ./ Inventario."Tareas") / 60
Inventario.Proceso .= "Inventario"

rename!(Inventario, Symbol("Contador") => :"Confirmado por")
rename!(Inventario, Symbol("Cantidad contada") => :Piezas)
rename!(Inventario, Symbol("volumencm3") => :Volumen)


Inventario = leftjoin(Inventario, base_empleados, on =:"Confirmado por")
Inventario.Fin = string.(Dates.format.(Inventario.Fin, "yyyy-mm-dd HH:MM:SS"))
Inventario.Inicio = string.(Dates.format.(Inventario.Inicio, "yyyy-mm-dd HH:MM:SS"))

condicion = coalesce.(Inventario.TURNO .== "Nocturno", false) .& coalesce.(Inventario."Hora de confirmación" .>= Time("21:00:00"), false)
Inventario.Fecha = ifelse.(condicion, coalesce.(Inventario."Fecha confirmación" .+ Day(1), missing), Inventario."Fecha confirmación")




CSV.write(joinpath(path,"Payment Support/base_csv/Inventario.csv"), Inventario)



## 🐶 REVISION Y EMBARQUE
#data_row, colnames = XLSX.readtable(dir_rrrp, "RPV2")
#produ_rrrp = DataFrame(data_row, Symbol.(colnames))
produ_rrrp = DataFrame(XLSX.readtable(dir_rrrp, "RPV2"))

rename!(produ_rrrp, Symbol("empleado") => :Empleado)
produ_rrrp = leftjoin(produ_rrrp, base_empleados, on =:Empleado)


## 🦋 3PL
# data_row, colnames = XLSX.readtable(dir_3pl, "Base_3pl")
# produ_3pl = DataFrame(data_row, Symbol.(colnames))

produ_3pl = DataFrame(XLSX.readtable(dir_3pl, "Base_3pl"))
rename!(produ_3pl, Symbol("empleado") => :Empleado)

produ_3pl = leftjoin(produ_3pl, base_empleados, on =:Empleado)




########################
########################




## Ahora pordemos hacer la base de RPV

### Agrupar data_sap

base_rpv = combine(groupby(data_sap, 
[:"Confirmado por", :"Empleado", :"Fecha", :"Centro" ,:"TURNO", :"Proceso", :"Area"]) ,
:"Ctd.real dest.UMB" => sum => :Piezas , 
:"Volumen de carga" => sum => :Volumen, 
nrow => :Renglones,
:"Tiempo" => sum => :Tiempo,
:"Inicio" => minimum => :Inicio,
:"Fin" => maximum => :Fin
)

base_rpv.Folios .= 0
base_rpv.Cajas .= 0
base_rpv.Tarimas .= 0

base_rpv.Codigos .= 0

base_rpv.Inicio = parse.(DateTime, base_rpv.Inicio, dateformat"yyyy-mm-dd HH:MM:SS")
base_rpv.Fin = parse.(DateTime, base_rpv.Fin, dateformat"yyyy-mm-dd HH:MM:SS")
base_rpv.Tiempo = ifelse.( base_rpv.Proceso .== "Recibo", (base_rpv.Fin .- base_rpv.Inicio) ./ Hour(1) , base_rpv.Tiempo)


## Agrupar Inventario

base_rpv_inventario = combine(
groupby(Inventario, [:"Confirmado por", :"Empleado", :"Fecha", :"Centro" ,:"TURNO", :"Proceso", :"Area"]),
nrow => :Renglones,
:Piezas => sum => :Piezas, 
:Volumen => sum => :Volumen,
:"Tiempo" => sum => :Tiempo,
:"Inicio" => minimum => :Inicio,
:"Fin" => maximum => :Fin
)

base_rpv_inventario.Folios .= 0
base_rpv_inventario.Cajas .= 0
base_rpv_inventario.Tarimas .= 0
base_rpv_inventario.Codigos .= 0

rename!(produ_rrrp, Symbol("fecha") => :Fecha)
rename!(produ_rrrp, Symbol("proceso") => :Proceso)
rename!(produ_rrrp, Symbol("area") => :Area)


base_rpv_mrrrp = combine(
groupby(produ_rrrp, [:"Confirmado por", :"Empleado", :"Fecha", :"Centro" ,:"TURNO", :"Proceso", :"Area"]),
:"renglones" => sum => :Renglones,
:"piezas" => sum => :Piezas,
:"folios" => sum => :Folios,
:"cajas" => sum => :Cajas,
:"tarimas" => sum => :Tarimas,
:"tiempo" => sum => :Tiempo
)


base_rpv_mrrrp.Volumen .= 0

base_rpv_mrrrp.Codigos .= 0

# δ = "2080-12-31 23:50:59"
# base_rpv_mrrrp.Inicio .= Dates.DateTime(δ, dateformat"yyyy-mm-dd HH:MM:SS")

base_rpv_mrrrp.Inicio .= ""

# α = "1500-12-31 23:50:59"

base_rpv_mrrrp.Fin .= ""

rename!(produ_3pl, Symbol("fecha") => :Fecha)
rename!(produ_3pl, Symbol("proceso") => :Proceso)

rename!(produ_3pl, Symbol("area") => :Area)

base_rpv_3pl = combine(
groupby(produ_3pl, [:"Confirmado por", :"Empleado", :"Fecha", :"Centro" ,:"TURNO", :"Proceso", :"Area"]),
:"renglones" => sum => :Renglones,
:"piezas" => sum => :Piezas,
:"volumen.cm3" => sum => :Volumen,
:"codigos" => sum => :Codigos,
:"cajas" => sum => :Cajas,
:"tarimas" => sum => :Tarimas,
:"tiempo" => sum => :Tiempo
)

base_rpv_3pl.Folios .= 0
base_rpv_3pl.Inicio .= ""
base_rpv_3pl.Fin .= ""


### De momento quito inventario
### base_rpv_inventario

#x = vcat(base_rpv, base_rpv_mrrrp)
x = vcat(base_rpv, base_rpv_mrrrp, base_rpv_3pl)
#x = vcat(base_rpv, base_rpv_inventario)

x.Renglones = coalesce.(x.Renglones, 0)
x.Piezas = coalesce.(x.Piezas, 0)
x.Volumen = coalesce.(x.Volumen, 0)

x.Folios = coalesce.(x.Folios, 0)
x.Cajas = coalesce.(x.Cajas, 0)

x.Tarimas = coalesce.(x.Tarimas, 0)
x.Codigos = coalesce.(x.Codigos, 0)


x.Tiempo = coalesce.(x.Tiempo, 0)



x.id = string.(x.Centro, x.TURNO, x.Proceso,x.Area)
CSV.write(joinpath(path,"Payment Support/base_csv/base_rpv.csv"), x)



file_objetivos = joinpath(path,"Payment Support/base_csv/objetivos.xlsx" )

# raw_data, colnames = XLSX.readtable(file_objetivos, "Objetivos")
# objetivos = DataFrame(raw_data, Symbol.(colnames))

objetivos = DataFrame(XLSX.readtable(file_objetivos, "Objetivos"))
obj = objetivos[:,[:id, :renglones_oj, :piezas_oj, :volumen_oj, :cajas_oj, :tarimas_oj, :folios_oj, :codigos_oj, :weight  ]]


## Me quedo con los usuarios que necesito y quito los tiempos de 0 horas
δ = x[.!ismissing.(x.TURNO) .& .!ismissing.(x.Tiempo) .& (x.Tiempo .> 0), :]
δ = leftjoin(δ , obj, on =:id)


## x.Piezas_hora = ifelse.( x.Tiempo .== 0, 0, coalesce.(x.Piezas, 0) ./ x.Tiempo )
## Calculo de Unidad por Hora
δ.Piezas_hora = coalesce.(δ.Piezas, 0) ./ δ.Tiempo
δ.Renglones_hora = coalesce.(δ.Renglones, 0) ./ δ.Tiempo
δ.Volumen_hora = coalesce.(δ.Volumen, 0) ./ δ.Tiempo
δ.Cajas_hora = coalesce.(δ.Cajas, 0) ./ δ.Tiempo
δ.Tarimas_hora = coalesce.(δ.Tarimas, 0) ./ δ.Tiempo

δ.Folios_hora = coalesce.(δ.Folios, 0) ./ δ.Tiempo
δ.Codigos_hora = coalesce.(δ.Codigos, 0) ./ δ.Tiempo

## coalesce objetivos
δ.piezas_oj = coalesce.(δ.piezas_oj, 0)
δ.renglones_oj = coalesce.(δ.renglones_oj,0)
δ.volumen_oj = coalesce.(δ.volumen_oj,0)


δ.cajas_oj = coalesce.(δ.cajas_oj,0)
δ.tarimas_oj = coalesce.(δ.tarimas_oj,0)

δ.folios_oj = coalesce.(δ.folios_oj,0)
δ.codigos_oj = coalesce.(δ.codigos_oj,0)

## Calculo de Calificaicon Obtenido
δ.Piezas_Obtenido = ifelse.(δ.piezas_oj .== 0, 0, δ.Piezas_hora ./ δ.piezas_oj)

δ.Renglones_Obtenido = ifelse.(δ.renglones_oj .== 0, 0, δ.Renglones_hora ./ δ.renglones_oj)
δ.Volumen_Obtenido = ifelse.(δ.volumen_oj .== 0, 0, δ.Volumen_hora ./ δ.volumen_oj)
δ.Cajas_Obtenido = ifelse.(δ.cajas_oj .== 0, 0, δ.Cajas_hora ./ δ.cajas_oj)
δ.Tarimas_Obtenido = ifelse.(δ.tarimas_oj .== 0, 0, δ.Tarimas_hora ./ δ.tarimas_oj)
δ.Folios_Obtenido = ifelse.(δ.folios_oj .== 0, 0, δ.Folios_hora ./ δ.folios_oj)
δ.Codigos_Obtenido = ifelse.(δ.codigos_oj .== 0, 0, δ.Codigos_hora ./ δ.codigos_oj)


## No se puede dividor por cero, 

δ.Piezas_Obtenido = min.(δ.Piezas_Obtenido, 3 )
δ.Renglones_Obtenido = min.(δ.Renglones_Obtenido, 3 )
δ.Volumen_Obtenido = min.(δ.Volumen_Obtenido, 3 )
δ.Cajas_Obtenido = min.(δ.Cajas_Obtenido, 3 )
δ.Tarimas_Obtenido = min.(δ.Tarimas_Obtenido, 3 )
δ.Folios_Obtenido = min.(δ.Folios_Obtenido, 3 )

δ.Codigos_Obtenido = min.(δ.Codigos_Obtenido, 3 )

## Calculamos el RPV por area 

δ.RPV = coalesce.(δ.weight, 0) .* (
    coalesce.(δ.Piezas_Obtenido, 0) .+
    coalesce.(δ.Renglones_Obtenido, 0) .+
    coalesce.(δ.Volumen_Obtenido, 0) .+
    coalesce.(δ.Cajas_Obtenido, 0) .+
    coalesce.(δ.Tarimas_Obtenido, 0) .+
    coalesce.(δ.Folios_Obtenido, 0) .+
    coalesce.(δ.Codigos_Obtenido, 0)
)

δ.RPV = min.(δ.RPV, 360)
δ.time_id = string.(δ.Empleado,δ.Fecha)


γ = δ[:,[:Fecha, :Empleado, :time_id, :Tiempo]]

γ = combine(groupby(γ, [:time_id]), :Tiempo => sum =>  :S_Tiempo )

δ = leftjoin(δ, γ, on =:time_id )
δ.Ponderado = (δ.Tiempo ./ δ.S_Tiempo ) .* δ.RPV

CSV.write(joinpath(path,"Payment Support/base_csv/base_rpv_clean.csv"), δ)

###  Tengo que homologar mis nombre de columnas 
# / para elimar una columna 
# / select!(df, Not(columna_eliminar))
# / para remplazar el valor de una columan 
# / replace!(df[!, columna_modificar], valor_a_buscar => nuevo_valor)

## CSV.write(joinpath(path,"Payment Support/base_csv/data_SAP.csv"), data_sap)       ## Query sap
## CSV.write(joinpath(path,"Payment Support/base_csv/Inventario.csv"), Inventario)   ## Inventario
## CSV.write(joinpath(path,"Payment Support/base_csv/base_rpv.csv"), x)              ## BRPV


