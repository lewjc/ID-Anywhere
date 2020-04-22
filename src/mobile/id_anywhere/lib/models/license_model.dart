class LicenseModel {
   String firstname;
   String lastname;
   String number;
   DateTime dateOfBirth;
   DateTime expiry;

  LicenseModel(
      {this.firstname, this.lastname, this.number, this.expiry, this.dateOfBirth});

  LicenseModel.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['lastname'],        
        number = json['number'],
        dateOfBirth = json['dateOfBirth'],
        expiry = json['expiry'];

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,        
        'number': number,
        'expiry': expiry.toIso8601String(),
        'dateOfBirth': dateOfBirth.toIso8601String()
      };

  bool isValid() {
    return this.firstname != null &&
        this.lastname != null &&        
        this.number != null &&
        this.dateOfBirth != null &&
        this.expiry != null;
  }
}
