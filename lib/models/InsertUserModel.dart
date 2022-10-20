import 'package:colombo_express_client/models/UserModel.dart';

class InsertUserModel {
  
  String? message;
  List<UserModel>? users;

  InsertUserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    users = List<UserModel>.from(
      json['data']['user'].map(
        (usersdata) => UserModel.fromJson(usersdata),
      ),
    );
  }
}
