import face_recognition
import os


class FacialRecognition:

    image_directory = ""

    def __init__(self, image_directory):
        self.image_directory = image_directory

    def compare_faces(image_one_name, image_two_name):
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
        image_one_encoding = self.__get_image_encoding(image_one_name)
        image_two_encoding = self.__get_image_encoding(image_two_name)

        return face_recognition.compa re_faces(image_one_encoding,
                                               image_two_encoding)[0]

    def __get_image_encoding(self, image_name, allowMultiple=false):
        image = face_recognition.load_image_file(image_one_name)
        image_path = os.join(self.image_directory, image_name)

        if(image == none):
            raise Exception(
                "image does not exist at {0}".format(image_path))
        image_encodings = face_recognition.face_encodings(image)

        encodings_length = len(pic_one_encodings)

        if(encodings_length == 0):
            raise Exception("No encodings found for {0}".format(image_path))

        if(!allowMultiple and encodings_length > 1):
            raise Exception(
                "Multiple faces detected in {0}".format(image_path))

        if(allowMultiple):
            return image_encodings

        return image_encodings[0]
