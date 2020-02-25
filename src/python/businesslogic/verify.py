from PIL import Image

from utility.ImageManipulation import ConvertImageToBW
import utility.facialrecognition as fr
from utility.TextManipulation import extract_driving_license_info
from requests import post
from utility.constants import UPDATE_USER_STATUS_URL
import utility.OCR as OCR
import io
import time
import re

r_compiled = re.compile(r'^[A-Z9]{5}\d{6}[A-Z9]{2}\d$', re.X)


def verify(passport_image_bytes: str, user_image_bytes: str,
           driving_license_text: str, passport_image_text: str):

    '''
    Get the job, from the app id, download the user image and passport
    compare this information and make sure that they match for facial rec.
    Then, we need to check mrz and get info off of it. date of birth, 
    the expiry and stuff...............
    '''
    # Convert the byte strings to images
    passport_image = Image.open(io.BytesIO(passport_image_bytes))
    user_image = Image.open(io.BytesIO(user_image_bytes))

    check_face_result = __check_face(passport_image, user_image)
    print(check_face_result)

    if(check_face_result is bool):
        # Passed the first check, verify the user's face matches their
        # passport now to verify date of birth and driving license number.
        __verify_age(passport_image_text, driving_license_text)

    else:   
        return check_face_result


def update_user_status(verified, response_message, guid):

    data = {
        "verified": verified,
        "message": response_message,
        "GUID": guid
    }

    try:
        response = post(UPDATE_USER_STATUS_URL, verify=False, data=data)
        if(response is None):
            print("API Call error")

        if(response.status_code == 200):
            return
        else:
            print("status code returned {}. expected 200 OK".format(
                response.status_code))
    except Exception as e:
        print(str(e))


def __check_face(passport_image, user_image):
    try:
        result = fr.compare_faces(passport_image, user_image),
        if(result):
            return (result, "Passport + Image identified")

        return (result, "Passport + Image not identified")

    except Exception as e:
        # Get the error message, then return that from our endpoint with an
        # error stating that the user's picutre upload was unexceptable using
        # str(e)
        print(e)
        return (False, "Error")


def __verify_age(passport_image_bytes, driving_license_image):
    '''
    Verifies the user's age and cross references information between the
    driving license and the passport.

    '''
    passport_mrz_data = __get_passport_info(passport_image_bytes)

    if(passport_mrz_data.valid_score < 50 or
       not passport_mrz_data.date_of_birth_valid):
        return False

    user_license_dob, user_license_number = __get_license_info(
        driving_license_image)

    # TODO: get the information out of the MRZ and compare the two dates.
    # possibly try and give this a trial run.

    passport_dob = passport_mrz_data.date_of_birth
    # Add spaces after each 2 characters in the string
    passport_dob = " ".join(passport_dob[i:i+2]
                            for i in range(0, len(passport_dob), 2))

    passport_dob = time.strptime(passport_dob, "%y %m %d")
    license_dob = time.strptime(user_license_dob, "%d-%m-%y")

    # TODO: Potentailly extract the first 5 letters of the last name from the
    # license number and then compare that to the last name extracted from the
    # passport mrz.

    if(passport_dob != license_dob):
        return False

    license_verified = __verify_driving_license_number(user_license_number)

    if(not license_verified):
        return False

    # Verified the dates of birth from the two identify documents


def __get_passport_info(passport_image):
    bw_passport_photo = ConvertImageToBW(passport_image)
    return OCR.read_mrz(bw_passport_photo)


def __get_license_info(driving_license_image):
    bw_driving_image = ConvertImageToBW(
        driving_license_image, threshold=65)
    driving_license_string = OCR.read_characters(bw_driving_image)
    return extract_driving_license_info(
        driving_license_string)


def __verify_driving_license_number(license_number):
    return re.match(r_compiled, license_number)
