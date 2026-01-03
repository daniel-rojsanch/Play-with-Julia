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
output_path = "C:\\Users\\Daniel_Rojas\\Nadro, S.A.P.I. de C.V\\Oficina Técnica - Documentos\\Documentos\\10.EtiquetaUbicaciones\\etiquetas_zebra_doble_51x25.txt"

# Abrimos el archivo para escribir
open(output_path, "w") do io
    i = 1
    while i <= nrow(data)
        # Primera etiqueta (izquierda)
        ubic1 = data[i, :Ubicacion]
        veri1 = data[i, :Verificacion]

        # Segunda etiqueta (derecha), si existe
        if i + 1 <= nrow(data)
            ubic2 = data[i+1, :Ubicacion]
            veri2 = data[i+1, :Verificacion]
        else
            ubic2 = ""
            veri2 = ""
        end

        # === Plantilla ZPL ajustada ===
        zpl = """
        ^XA
        ^CI28
        ^PW812
        ^LL203

        ^FX ===== Etiqueta izquierda =====
        ^LH40,40
        ^FO40,10
        ^BY2,2,60
        ^BCN,60,N,N,N
        ^FD$veri1^FS
        ^CF0,40
        ^FO80,100^FD$ubic1^FS

        ^FX ===== Etiqueta derecha =====
        ^LH446,40
        ^FO40,10
        ^BY2,2,60
        ^BCN,60,N,N,N
        ^FD$veri2^FS
        ^CF0,40
        ^FO80,100^FD$ubic2^FS

        ^XZ
        """

        write(io, zpl * "\n\n")
        i += 2
    end
end

println("✅ Archivo ZPL doble (ajustado 0.5 cm desplazamiento y texto más alto) generado en: $output_path")
