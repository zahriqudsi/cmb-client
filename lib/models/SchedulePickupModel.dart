class SchedulePickupModel {
  int? code;
  String? action;
  String? message;
  Errors? errors;

  SchedulePickupModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    action = json['action'];
    message = json['message'];
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['code'] = this.code;
  //   data['action'] = this.action;
  //   data['message'] = this.message;
  //   if (this.errors != null) {
  //     data['errors'] = this.errors!.toJson();
  //   }
  //   return data;
  // }
}

class Errors {
  List<String>? from;

  // Errors({this.from});

  Errors.fromJson(Map<String, dynamic> json) {
    from = json['from'].cast<String>();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['from'] = this.from;
  //   return data;
  // }
}
