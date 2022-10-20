class CityModel {
  late int id;
  late String city;
  late int stateId;
  late int adminId;

  
  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    stateId = json['state_id'];
    adminId = json['admin_id'];
  }
}
