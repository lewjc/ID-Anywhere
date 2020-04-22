import face_recognition
import os
import numpy as np


def compare_faces(image_one, image_two):
    """
Compares the face found in image_one_name and image_two_name to
    determine if they are the same or not.

    :param str image_one_name: file name of the first image
        e.g. example1.jpg
    :param str image_two_name: file name of the second image
        e.g. example2.jpg
    :return: boolean value representing if the two images presented
        contain the same person/face.
    """
    image_one_encoding = __get_image_encoding(image_one)
    image_two_encoding = __get_image_encoding(image_two)
<<<<<<< HEAD:src/python/Utility/FacialRecognition.py
    return face_recognition.compare_faces([image_one_encoding],
                                          image_two_encoding)[0]


def __get_image_encoding(image, allowMultiple=False):
=======
    matches = face_recognition.compare_faces(image_one_encoding,
                                            image_two_encoding[0])
    return any(matches)


def __get_image_encoding(image, allowMultiple=True):
>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/utility/facialrecognition.py

    if(image is None):
        raise Exception("Image provided is None.")
    image_encodings = face_recognition.face_encodings(np.array(image))
    encodings_length = len(image_encodings)

    if(encodings_length == 0):
        raise Exception("No encodings found for {0}".format(image_path))

    if(not allowMultiple and encodings_length > 1):
        raise Exception(
            "Multiple faces detected in {0}".format(image_path))

<<<<<<< HEAD:src/python/Utility/FacialRecognition.py
    if(allowMultiple):
        return image_encodings

    return image_encodings[0]
=======
    if(allowMultiple and len(image_encodings) > 1):
        return image_encodings

    return [image_encodings[0]]
>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/utility/facialrecognition.py
