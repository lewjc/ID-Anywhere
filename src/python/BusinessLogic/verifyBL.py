from PIL import Image
from Utility.ImageManipulation import ConvertImageToBW
from Utility.FacialRecognition import FacialRecognition
import Utility.OCR as OCR
from Utility.TextManipulation import extract_driving_license_info
import io
import time


def verify(passport_image_bytes, user_image_bytes,
           driving_license_image_bytes):
    ''''''
    # Convert the byte strings to images
    passport_image = Image.open(io.BytesIO(passport_image_bytes))
    user_image = Image.open(io.BytesIO(user_image_bytes))
    driving_license_image = Image.open(
        io.BytesIO(driving_license_image_bytes))

    check_face_result = __check_face(passport_image, user_image)

    if(check_face_result is bool):
        # Passed the first check, verify the user's face matches their
        # passport now to verify date of birth and driving license number.
        __verify_age(passport_image_bytes, driving_license_image)

    else:
        return check_face_result


def __check_face(passport_image, user_image):
    try:
        fr = FacialRecognition()
        return fr.compare_faces(passport_image, user_image)
    except Exception as e:
        # Get the error message, then return that from our endpoint with an
        # error stating that the user's picutre upload was unexceptable using
        # str(e)
        return (False, str(e))


def __verify_age(passport_image_bytes, driving_license_image):
    '''
    Verifies the user's age and cross references information between the
    driving license and the passport.

    '''
    passport_mrz_data = __get_passport_info(passport_image_bytes)

    if(passport_mrz_data.valid_score < 50):
        return False

    user_license_dob, user_license_number = __get_license_info(
        driving_license_image)

    # TODO: get the information out of the MRZ and compare the two dates.
    # possibly try and give this a trial run.

    passport_dob = passport_mrz_data.date_of_birth
    # Add spaces after each 2 characters in the string
    passport_dob = " ".join(s[i:i+2] for i in range(0, len(passport_dob), 2))
    passport_dob = time.strptime(passport_dob, "%y %m %d")
    license_dob = time.strptime(user_license_dob, "%d-%m-%y")


def __get_passport_info(passport_image):
    bw_passport_photo = ConvertImageToBW(passport_image)
    return OCR.read_mrz(bw_passport_photo)


def __get_license_info(driving_license_image):
    bw_driving_image = ConvertImageToBW(
        driving_license_image, threshold=65)
    driving_license_string = OCR.read_characters(bw_driving_image)
    return extract_driving_license_info(
        driving_license_string)
