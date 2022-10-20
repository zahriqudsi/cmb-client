import 'package:colombo_express_client/models/CityModel.dart';
import 'package:colombo_express_client/models/CountryModel.dart';
import 'package:colombo_express_client/models/StateModel.dart';

class AddressModel {
  int? addressid;
  String? label;
  String? fName;
  String? lName;
  String? phone;
  String? address;
  String? zipCode;
  String? name;
  String? fullAddress;
  CityModel? city;
  StateModel? state;
  CountryModel? country;

  AddressModel.fromJson(Map<String, dynamic> json) {
    addressid = json['id'];
    label = json['label'];
    fName = json['first_name'];
    lName = json['last_name'];
    phone = json['phone'];
    address = json['address'];
    zipCode = json['zip_code'];
    name = json['name'];
    fullAddress = json['full_address'];
    city = CityModel.fromJson(json['city']);
    state = StateModel.fromJson(json['state']);
    country = CountryModel.fromJson(json['country']);
  }
}
