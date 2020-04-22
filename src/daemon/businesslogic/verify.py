from utility.imagemanipulation import ConvertImageToBW
import utility.facialrecognition as fr
from utility.textmanipulation import extract_driving_license_info
from requests import post
from utility.constants import UPDATE_USER_STATUS_URL
from PIL import Image
import io
import json
import time
import re
import os
import pathlib
import datetime
from passporteye import read_mrz
import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage

r_compiled = re.compile(r'^[A-Z9]{5}\d{6}[A-Z9]{2}\d[A-Z]{2}$', re.I)

path = os.path.join(os.getcwd(), "dissertation-498be-firebase-adminsdk-od080-e7eb596b9e.json")
cred = credentials.Certificate(path)

app = firebase_admin.initialize_app(cred, {
    'storageBucket': 'dissertation-498be.appspot.com'
}, name='storage')


def verify(job: dict):

    '''
    Get the job, from the app id, download the user image and passport
    compare this information and make sure that they match for facial rec.
    Then, we need to check mrz and get info off of it. date of birth, 
    the expiry and stuff...............
    '''
    # Convert the byte strings to images


    bucket = storage.bucket(app=app)

    default_bucket = "userinf/{}/".format(job['AppID'])
    passport_image_blob = default_bucket + "passport"
    user_image_blob = default_bucket + "profile_picture"
    passport_image_blob = bucket.blob(passport_image_blob)
    user_image_blob = bucket.blob(user_image_blob)

    passport_bytes = passport_image_blob.download_as_string()
    profile_picture_bytes = user_image_blob.download_as_string()

    passport_image = Image.open(io.BytesIO(passport_bytes))
    user_image = Image.open(io.BytesIO(profile_picture_bytes))

    check_face_result = __check_face(passport_image, user_image)

    if(check_face_result[0]):
        # Passed the first check, verify the user's face matches their
        # passport now to verify date of biheaders = {'content-type': 'application/json'}rth and driving license number.
        return __verify_age(io.BytesIO(passport_bytes), job)            
    else:
        return check_face_result


def update_user_status(verified, response_message, id):

    data = {
        "Verified": verified,
        "Message": str(response_message),
        "UserId": str(id)
    }

    try:
        response = post(UPDATE_USER_STATUS_URL, verify=True, data=json.dumps(data), headers={'content-type': 'application/json'})
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
        result = fr.compare_faces(passport_image, user_image)
        if(result):
            return (result, "Passport + Image identified")

        return (result, "Passport + Image not identified")

    except Exception as e:
        # Get the error message, then return that from our endpoint with an
        # error stating that the user's picutre upload was unexceptable using
        # str(e)
        print(e)
        return (False, "Error")


def __verify_age(passport_bytes, job):
    '''
    Verifies the user's age and cross references information between the
    driving license and the passport.

    if failed, just check the information provided.
    get mrz date of birth, get date of birth from the data provided. compare, then compare with the driving license.
    Finally, check the driving license number, make sure that the ifnroamtion in that matches the date of birth in teh license.

    make sure the documents are not expired. then post and we can now look to display the info/.    
    TOMORROW> Get this finished, then commit and fix up the api and app.

    From there, we need to verify the images. Once those are done then we need to develop the admin lgoin, to then verify new users.
    Once verified, tehe user can request a code. Once a code is made in the API then we can hold that in the database.

    When scanned by the POS, we know that we can verify through the api.  

    '''
    passport_mrz_data = read_mrz(passport_bytes)

    if(passport_mrz_data.valid_score < 50 or
       not passport_mrz_data.valid_date_of_birth):
        print("Failed MRZ checker.")

    license_data = job["LicenseData"]
    passport_data = job["PassportData"]
    passport_dob = passport_mrz_data.date_of_birth
    # Add spaces after each 2 characters in the string
    passport_dob = " ".join(passport_dob[i:i+2]
                            for i in range(0, len(passport_dob), 2))

    passport_dob = time.strptime(passport_dob, "%y %m %d")
    errors_in_data = compare_mobile_data(license_data, passport_data)

    if(errors_in_data > 3 or errors_in_data < 0):
        return (False, "Quality of information provided not good enough.")
    
    return (True, "Information provided is sutiable")


def compare_mobile_data(license_data: dict, passport_data: dict):

    today = datetime.datetime.now().date()
    error_count = 0

    if (not (license_data["FirstName"].lower() ==
        passport_data["FirstName"].lower())):
        error_count +=1
    if (not (license_data["LastName"].lower() ==
        passport_data["LastName"].lower())):
       error_count +=1
    if (not (license_data["DateOfBirth"].date() ==
        passport_data["DateOfBirth"].date())):
       error_count +=1
    else:
        if(not __verify_driving_license_number(license_data["Number"])):
            error_count +=1 
        else:
            dob_from_number = license_data["Number"][5:11]
            year = dob_from_number[0]+dob_from_number[-1]
            month = int(dob_from_number[1] + dob_from_number[2])
            day = int(dob_from_number[3] + dob_from_number[4])

            current_year = datetime.datetime.now().year
            prefix = 20
            if(current_year - 2000 < int(year)):
                prefix = 19
            year = int("{}{}".format(prefix, year))
            dob_from_number = datetime.datetime(year, month, day).date()

            if(not dob_from_number == license_data["DateOfBirth"].date()):
                error_count +=1
    
    if(not license_data["Expiry"].date() > today and passport_data["Expiry"].date() > today):
        return -1
    
    
    return error_count
        

def __verify_driving_license_number(license_number):
    return re.match(r_compiled, license_number)
