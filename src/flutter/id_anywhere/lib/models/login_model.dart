class LoginModel {

  final String email;
  // Password should always be a hash.
  final String password;

  
  LoginModel({ 
    this.email,
    this.password
  });

  LoginModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
    {      
      'email': email,
      'password': password
    };

  bool isValid(){
    return 
    (this.email != null &&
    this.password != null);
  }
}