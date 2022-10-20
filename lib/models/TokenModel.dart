import 'UserModel.dart';

class TokenModel {
  late String token;
  UserModel? user;

  TokenModel({
    required this.token,
    this.user,
  });

  TokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = UserModel.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = this.token;
    data['user'] = this.user;

    return data;
  }
}
