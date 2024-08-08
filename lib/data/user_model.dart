class UserModel {
  late String? email;
  late String? password;
  late String? access_token;
  late String? token_type;

  UserModel({
    this.email,
    this.password,
    this.access_token,
    this.token_type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      access_token: json['access_token'],
      token_type: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'access_token': access_token,
      'token_type': token_type,
    };
  }
}
