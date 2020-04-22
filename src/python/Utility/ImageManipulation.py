from PIL import Image
from io import BytesIO
from pathlib import Path
import os
import uuid


def ConvertImageToBW(image, threshold=128):

    gray = image.convert('L')
    # 128 for passport
    # 60 for license
    bw = gray.point(lambda x: 255 if x > threshold else x, '1')
    return bw


def ConvertImageBytesToBW(image_bytes, threshold=150):

    with Image.open(BytesIO(image_bytes)) as img:
        print("converting image")

        _dir = os.path.dirname(__file__)

        save_path = os.path.join(_dir, "/temp/{}.png".format(
            uuid.uuid4()))

        img.save(save_path)

        # img = Image.open(save_path)

        # bw = img.convert('L')

        # img.show()

        # bw = bw.point(lambda x: 255 if x > threshold else x)
        # bw.show()
        # bw.save(save_path, quality=100)
        # b = BytesIO()
        # bw.save(b, "png", quality=100, compression=0)
        # print("finished converting")
        # return b.getvalue()

#     with Image.frombytes("RGB", (width, height), image_bytes) as img:
#         bw = img.convert('L')
#         # 128 for passport
#         # 60 for license
#         bw = bw.point(lambda x: 0 if x < threshold else 255, '1')
#         b = BytesIO()
#         bw.save(b, format="png", subsampling=0, quality=95)
#         return b.getvalue()
