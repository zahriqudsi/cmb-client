import 'package:colombo_express_client/models/AddressModel.dart';

class UserModel {
  late int id;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  int? status;
  int? addressId;
  String? createdAt;
  String? updatedAt;
  String? name;
  AddressModel? addressModel;

  // UserModel({
  //   this.id,
  //   this.firstName,
  //   this.lastName,
  //   this.email,
  //   this.emailVerifiedAt,
  //   this.status,
  //   this.addressId,
  //   this.createdAt,
  //   this.updatedAt,
  //   this.name,
  //   this.addressModel,

  // });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    status = json['status'];
    addressId = json['address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    if (json['address'] != null) {
      addressModel = AddressModel.fromJson(json['address']);
    }
  }
}
