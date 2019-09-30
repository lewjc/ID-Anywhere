from PIL import Image
import pytesseract
from passporteye import read_mrz


def read_characters(image):
    text = pytesseract.image_to_string(Image)
    return text


def read_mrz(image):
    '''
    Attempts to find and read a machine readable zone on the presented image.
    :param Image image: the image to check for an MRZ.
    :return: an mrz object containing information pertaining to how
    the MRZ is represented. (None if no MRZ detected.)
    '''
    return read_mrz(image)
    