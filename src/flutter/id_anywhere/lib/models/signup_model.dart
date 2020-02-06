class SignupModel {

  final String firstname;
  final String lastname;
  final String email;

  // Password should always be a hash.
  final String password;
  final String appID;

  
  SignupModel({
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.appID
  });

  SignupModel.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['surname'],
        email = json['email'],
        password = json['password'],
        appID = json['appID'];

  Map<String, dynamic> toJson() =>
    {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'appID': appID
    };

  bool isValid(){
    return 
    (this.firstname != null &&
    this.lastname != null &&
    this.email != null &&
    this.password != null &&
    this.appID != null
    );
  }
}