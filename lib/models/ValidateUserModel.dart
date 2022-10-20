class ValidateUserModel {
  int? code;
  String? action;
  String? message;
  Errors? errors;

  ValidateUserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    action = json['action'];
    message = json['message'];
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class Errors {
  List<String>? email;

  Errors({this.email});

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}
