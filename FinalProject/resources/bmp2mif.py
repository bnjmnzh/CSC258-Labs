from PIL import Image
import sys


def bmp_to_mif(bmp_file):
    f = open(bmp_file[:-4] + ".mif", "w")

    img = Image.open(bmp_file)

    dimension_x = img.size[0]
    dimension_y = img.size[1]

    bit_depth = dimension_x * dimension_y
    bit_width = 3

    f.write("WIDTH={};\n".format(bit_width))
    f.write("DEPTH={};\n".format(bit_depth))
    f.write("\n")
    f.write("ADDRESS_RADIX=UNS;\n")
    f.write("DATA_RADIX=UNS;\n")
    f.write("\n")
    f.write("CONTENT BEGIN\n")

    start_address = 0

    for y in range(0, dimension_y):
        for x in range(0, dimension_x):

            pixel = get_pixel(x, y, img)
            next_pixel = get_next_pixel(x, y, img)
            address = get_address(x, y, dimension_x)

            if pixel != next_pixel:
                line = format_line(start_address, address, pixel)
                start_address = address + 1
                f.write("\t{}\n".format(line))

    f.write("END;")


def get_pixel(x, y, img):
    in_pixel = img.getpixel((x, y))
    r = 1 if in_pixel[0] > 100 else 0
    g = 1 if in_pixel[1] > 100 else 0
    b = 1 if in_pixel[2] > 100 else 0
    return r, g, b


def get_next_pixel(x, y, img):
    next_x = x + 1 if x + 1 < img.size[0] else 0
    next_y = y + 1 if next_x == 0 else y

    if next_y < img.size[1]:
        return get_pixel(next_x, next_y, img)
    else:
        return None


def get_address(x, y, dimension_x):
    return x + dimension_x * y


def format_line(start_address, end_address, pixel):
    uns_pixel = int("".join(str(i) for i in pixel), 2)
    if start_address != end_address:
        return "[{}..{}] : {};".format(start_address, end_address, uns_pixel)
    else:
        return "{} : {};".format(start_address, uns_pixel)


bmp_to_mif(sys.argv[1])