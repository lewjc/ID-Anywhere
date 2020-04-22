from PIL import Image
import pytesseract
from passporteye import read_mrz
from io import BytesIO


def read_characters(image):
    text = pytesseract.image_to_string(Image, lang="OCRB")
    return text


def extract_mrz(image_bytes):
    '''
    Attempts to find and read a machine readable zone on the presented image.
    :param Image image: the image to check for an MRZ.
    :return: an mrz object containing information pertaining to how
    the MRZ is represented. (None if no MRZ detected.)
    '''
    print("reading mrz")
    mrz = read_mrz(image_bytes)
    print("mrz read")
    return mrz
