using Images, FileIO
using ImageMagick
using Printf

input_path  = "aa.jpg"
output_path = "imagen_1mb.jpg"

img = load(input_path)

max_size = 1_000_000  # 1 MB en bytes
quality = 85

while true
    save(output_path, img; quality=quality)
    size = filesize(output_path)

    @printf("Calidad: %d | Tamaño: %.2f KB\n", quality, size / 1024)

    if size ≤ max_size || quality ≤ 30
        break
    end

    quality -= 5
end

println("Imagen final guardada en: ", output_path)
