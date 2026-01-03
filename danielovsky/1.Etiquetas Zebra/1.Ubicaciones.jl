using XLSX
using CSV
using DataFrames
using Gtk   

## Seleccionamos el archivo de Ubicaciones 
filename = open_dialog("Selecciona un archivo Excel", GtkNullContainer())
data = DataFrame(XLSX.readtable(filename, "Sheet1"))

# Seleccionar solo las columnas requeridas
data = data[:, ["Ubicación", "Campo verific.en registro datos móvil"]]

# Renombrar columnas para mayor claridad
rename!(data, Dict("Ubicación" => :Ubicacion, "Campo verific.en registro datos móvil" => :Verificacion))

# Ruta de salida

output_path = "C:\\Users\\Daniel_Rojas\\Nadro, S.A.P.I. de C.V\\Oficina Técnica - Documentos\\Documentos\\10.EtiquetaUbicaciones\\etiquetas_zebra.txt"

# Abrimos el archivo para escribir
open(output_path, "w") do io
    for row in eachrow(data)
        ubic = row.Ubicacion
        veri = row.Verificacion

        # === Plantilla ZPL para etiqueta 4x2 pulgadas ===
        zpl = """
        ^XA
        ^CI28
        ^PW812
        ^LL406
        ^LH0,0

        ^FX ===== Código de barras =====
        ^FO110,40
        ^BY4,3,160
        ^BCN,160,N,N,N
        ^FD$veri^FS

        ^FX ===== Texto de ubicación grande debajo =====
        ^CF0,120
        ^FO150,260^FD$ubic^FS

        ^XZ
        """

        # Escribimos al archivo (una etiqueta por fila)
        write(io, zpl * "\n\n")
    end
end

println("✅ Archivo ZPL generado en: $output_path")
 