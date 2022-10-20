class CountryModel {
  late int id;
  late String country;
  late String isoCOde;
  late String phoneCode;
  late int adminId;

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    isoCOde = json['iso_code'];
    phoneCode = json['phone_code'];
    adminId = json['admin_id'];
  }
}
