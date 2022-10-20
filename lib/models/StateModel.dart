class StateModel {
  late int id;
  late String state;
  late int countryId;
  late int adminId;
  late String createdAt;
  late String updatedAt;

  
  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    countryId = json['country_id'];
    adminId = json['admin_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['state'] = this.state;
  //   data['country_id'] = this.countryId;
  //   data['admin_id'] = this.adminId;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   return data;
  // }
}
