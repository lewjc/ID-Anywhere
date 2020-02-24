class PassportModel {
  final String firstname;
  final String lastname;
  final String mrz;
  final String number;
  final DateTime dateOfBirth;
  final DateTime expiry;

  PassportModel(
      {this.firstname, this.lastname, this.mrz, this.number, this.expiry, this.dateOfBirth});

  PassportModel.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['lastname'],
        mrz = json['mrz'],
        number = json['number'],
        dateOfBirth = json['dateOfBirth'],
        expiry = json['expiry'];

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'mrz': mrz,
        'number': number,
        'expiry': expiry.toIso8601String(),
        'dateOfBirth': dateOfBirth.toIso8601String()
      };

  bool isValid() {
    return this.firstname != null &&
        this.lastname != null &&
        this.mrz != null &&
        this.number != null &&
        this.dateOfBirth != null &&
        this.expiry != null;
  }
}
