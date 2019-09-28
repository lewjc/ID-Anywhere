

def extract_driving_license_info(license_text):
    # The two pieces of information that we are interested
    # in are the driving license number and the date of birth.
    # Usually in the form
    # 3.  01.01.1990
    # 5.  AAAAA901010AB0CD
    dob = extract_dob(license_text)
    license_number = extract_driving_license_number(license)
    return(dob, license_number)


def extract_dob(license_text):
    license_text = str(license_text).trim()
    indicator_index = license_text.find("3.")
    dob = license_text[indicator_index++:]
    dob = dob.replace(" ", "-")
    license_number_end = dob.rfind("-")
    dob = dob[:license_number_end].replace("-", "")
    return dob


def extract_driving_license_number(license_text):
    license_text = str(license_text).trim()
    indicator_index = license_text.find("5.")
    license_number = license_text[indicator_index++:]
    license_number = license_number.replace(" ", "-")
    license_number_end = license_number.rfind("-")
    license_number = license_number[:license_number_end].replace("-", "")
    return
