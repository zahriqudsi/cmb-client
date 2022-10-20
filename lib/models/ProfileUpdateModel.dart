import 'package:colombo_express_client/models/UserModel.dart';

class ProfileUpdateModel {
  ProfileUpdateModel({
    required this.message,
    required this.user,
  });

  late final String message;
  late final UserModel user;

  ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = UserModel.fromJson(json['data']);
  }

  // Map<String, dynamic> toJson() {
  //   final _data = <String, dynamic>{};

  //   _data['message'] = message;
  //   _data['data'] = user.toJson();
  //   return _data;
  // }
}
