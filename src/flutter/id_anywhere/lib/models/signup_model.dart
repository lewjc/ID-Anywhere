class SignupModel {

  final String firstname;
  final String lastname;
  final String email;

  // Password should always be a hash.
  final String password;

  
  SignupModel({
    this.firstname,
    this.lastname,
    this.email,
    this.password
  });

  SignupModel.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['surname'],
        email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
    {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password
    };

  bool isValid(){
    return 
    (this.firstname != null &&
    this.lastname != null &&
    this.email != null &&
    this.password != null);
  }
}