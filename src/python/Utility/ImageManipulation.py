from PIL import Image


def ConvertImageToBW(image_location, threshold=128):
    col = Image.open(image_location)
    gray = col.convert('L')
    # 128 for passport
    # 60 for license
    bw = gray.point(lambda x: 0 if x < threshold else 255, '1')
    return bw
