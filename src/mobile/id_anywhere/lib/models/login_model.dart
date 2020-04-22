class LoginModel {

  final String email;
  // Password should always be a hash.
  final String password;

  final String appID;
  
  LoginModel({ 
    this.email,
    this.password,
    this.appID
  });

  LoginModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        appID = json['appID'];

  Map<String, dynamic> toJson() =>
    {      
      'email': email,
      'password': password,
      'appID': appID
    };

  bool isValid(){
    return 
    (this.email != null &&
    this.password != null &&
    this.appID != null);
  }
}