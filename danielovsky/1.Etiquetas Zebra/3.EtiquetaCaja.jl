using XLSX
using DataFrames
using CSV

dir_JRs = "C:\\Users\\Daniel_Rojas\\Documents\\nuevo_daniel.XLSX"



## EMP = DataFrame(XLSX.readtable(filename, "Sheet1"))
dir_UMA = "C:\\Users\\Daniel_Rojas\\Documents\\UMA_3.XLSX"


pedidos = DataFrame(XLSX.readtable(dir_JRs, "Sheet1")) 
rename!(pedidos, Symbol("Prod.") => :Producto)
rename!(pedidos, Symbol("Descripción de producto") => :Descripcion)


pedidos.Producto = strip.(string.(pedidos.Producto))


UMA = DataFrame(XLSX.readtable(dir_UMA, "EMP"))
UMA.Producto = strip.(string.(UMA.Producto))
UMA_2 = UMA[:, [:Producto, Symbol("Código EAN/UPC"), :Numerador]]
rename!(UMA_2, Symbol("Código EAN/UPC") => :EAN_UPC, :Numerador => :Pzs_x_EMP)

pedidos_2 = leftjoin(pedidos, UMA_2, on=:Producto)
pedidos_2.Cajas = floor.(Int, pedidos_2."Ctd." ./ pedidos_2.Pzs_x_EMP)



pedidos_2.Cajas = ifelse.(
    ismissing.(pedidos_2."Ctd.") .| ismissing.(pedidos_2.Pzs_x_EMP),
    missing,
    floor.(Int, pedidos_2."Ctd." ./ pedidos_2.Pzs_x_EMP)
)

pedidos_3 = pedidos_2[:, [:Producto , :Descripcion, :Cajas, :EAN_UPC, :Lote, :Pzs_x_EMP]]


# Repetir filas según la columna Cajas
df_expandido = vcat([
    repeat(pedidos_3[i:i, :], inner = Int(pedidos_3.Cajas[i]))
    for i in 1:nrow(pedidos_3)
]...)



################
################
# ==========================
# CONFIGURACIÓN DE ETIQUETA
# ==========================
const DPI_203 = (pw = 812, ll = 406)          # 4x2" @ 203dpi
# const DPI_300 = (pw = 1200, ll = 600)       # 4x2" @ 300dpi (si tu impresora es de 300 dpi)

const PW = DPI_203.pw

const LL = DPI_203.ll

# Margen superior/izquierdo (Label Home)
const LH_X = 20 + 30
const LH_Y = 20

# Tipografías (fuentes por defecto de Zebra)
# ^A0N,h,w  (alto y ancho en dots; mantener proporción suele ir bien)
const FONT_BIG_H = 40
const FONT_BIG_W = 40
const FONT_TXT_H = 28

const FONT_TXT_W = 28

# Bloque de texto para descripción
const FB_WIDTH = PW - (LH_X + 40)           # ancho disponible del bloque de texto
const FB_MAX_LINES = 2
const FB_LINE_SPACING = 6
   
# Código de barras
const BAR_MODULE_WIDTH = 2      # ^BY w
const BAR_RATIO = 3             # ^BY r
const BAR_HEIGHT = 140          # ^BY h
const BAR_Y = 200               # posición Y de código de barras

# ==========================
# UTILIDADES
# ==========================
# Limpia y normaliza strings para ZPL (quita saltos de línea, recorta)
sanitize(s) = s === missing ? "" : replace(String(s), r"[\r\n]+" => " ") |> strip

# Deja sólo dígitos en el EAN/UPC (por si viene con espacios, guiones, etc.)
digits_only(s) = replace(sanitize(s), r"\D" => "")

# Detecta simbología según longitud: 12=UPC-A, 13=EAN-13, otro=Code128
function barcode_command(ean::AbstractString)
    n = length(ean)
    if n == 12
        # UPC-A
        return "^BY$(BAR_MODULE_WIDTH),$(BAR_RATIO),$(BAR_HEIGHT)\n^BUN,$(BAR_HEIGHT),Y,Y,N"
    elseif n == 13
        # EAN-13
        return "^BY$(BAR_MODULE_WIDTH),$(BAR_RATIO),$(BAR_HEIGHT)\n^BEN,$(BAR_HEIGHT),Y,N"
    else
        # Code128
        return "^BY$(BAR_MODULE_WIDTH),$(BAR_RATIO),$(BAR_HEIGHT)\n^BCN,$(BAR_HEIGHT),Y,N,N"
    end
end



# Genera el ZPL para una fila (Pzs_x_EMP obligatorio)
function zpl_for_row(producto, descripcion, ean_upc, lote, pzs_x_emp)
    prod   = sanitize(producto)
    desc   = sanitize(descripcion)
    lote_s = sanitize(lote)
    ean    = digits_only(ean_upc)
    pzs_txt = sanitize(pzs_x_emp)

    bc = barcode_command(ean)

    return """
^XA
^CI28
^PW$PW
^LL$(lpad(string(LL),4,'0'))
^LS0
^LH$LH_X,$LH_Y

^FX ===== Encabezado: Producto =====
^FO10,10^A0N,$(FONT_BIG_H),$(FONT_BIG_W)^FDMATERIAL: $prod^FS

^FX ===== Descripción (bloque con ^FB) =====
^FO10,60^A0N,$(FONT_TXT_H),$(FONT_TXT_W)^FB$FB_WIDTH,$FB_MAX_LINES,$FB_LINE_SPACING,L,0^FD$desc^FS

^FX ===== Lote =====
^FO10,120^A0N,$(FONT_TXT_H),$(FONT_TXT_W)^FDLOTE: $lote_s^FS

^FX ===== Pzs por Empaque =====
^FO400,120^A0N,$(FONT_TXT_H),$(FONT_TXT_W)^FDPZS x EMP: $pzs_txt^FS

^FX ===== Código de Barras =====
^FO10,$BAR_Y
$bc
^FD$ean^FS


^XZ
"""
end

# ==========================
# EJEMPLO DE USO
# ==========================
# Supón que ya tienes tu DataFrame `df` con columnas:
# :Producto, :Descripcion, :EAN_UPC, :Lote
# (Asegúrate de que los nombres de columnas coincidan exactamente)

# Ejemplo mínimo:
# df = DataFrame(Producto=["A123","B234"],
#                Descripcion=["MELOX PLUS 360 ML SUSP", "ACETAMINOFÉN 500 MG 24TABS"],
#                EAN_UPC=["7501234567890", "012345678905"], # 13=EAN, 12=UPC
#                Lote=["L2309A","L2401B"])
# Exporta todas las filas a un TXT con ZPL (requiere Pzs_x_EMP)


df = df_expandido



# Reemplaza tus utilidades por estas versiones
function sanitize(s)
    if s === missing
        return ""
    end
    t = string(s)                           # <- convierte lo que sea (Int, Float, etc.) a texto
    return strip(replace(t, r"[\r\n]+" => " "))
end

digits_only(s) = replace(sanitize(s), r"\D+" => "")


function export_zpl(df::DataFrame; outfile::AbstractString = "etiquetas_4x2.txt")
    # Usa Symbols en ambos lados de la comparación
    required = [:Producto, :Descripcion, :EAN_UPC, :Lote, :Pzs_x_EMP]
    present  = Set(Symbol.(names(df)))   # <- aquí el cambio
    missing  = [c for c in required if !(c in present)]
    @assert isempty(missing) "Faltan columnas: $(missing). Presentes: $(collect(present))"

    labels = String[]
    sizehint!(labels, nrow(df))

    for row in eachrow(df)
        push!(labels, zpl_for_row(row.Producto, row.Descripcion, row.EAN_UPC,  row.Lote,  row.Pzs_x_EMP))
    end

    open(outfile, "w") do io
        write(io, join(labels, "\n"))
    end

    println("Archivo ZPL generado: $(outfile)")
    return outfile
end


# Llama:
export_zpl(df; outfile="C:\\Users\\Daniel_Rojas\\Documents\\DANIELO.txt")
# Luego puedes enviar ese TXT a la impresora Zebra (Zebra Setup Utilities / driver) y listo.

