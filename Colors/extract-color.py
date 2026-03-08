from PIL import Image

def to_hex(rgb):
    return "#{:02x}{:02x}{:02x}".format(*rgb)

def main():
    path = input("Enter image file path: ").strip()
    try:
        img = Image.open(path).convert("RGBA")
    except Exception as e:
        print("Error opening file:", e)
        return

    pixels = img.getdata()

    unique_colors = sorted(set(pixels))

    print("\nTotal unique colors found:", len(unique_colors))

    print("\nRGBA colors:")
    for c in unique_colors:
        print("rgba({},{},{},{})".format(c[0], c[1], c[2], c[3]))

    print("\nHEX colors:")
    for c in unique_colors:
        # ignore alpha for hex, RGB only
        print(to_hex(c[:3]))

if __name__ == "__main__":
    main()
