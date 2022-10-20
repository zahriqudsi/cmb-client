class ShipmentCustomerModel {
  late int id;
  late String firstname;
  late String lastname;
  late String email;
  late String status;
  late String addressid;
  late String name;

  ShipmentCustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['first_name'];
    lastname = json['last_name'];
    email = json['email'];
    status = json['status'];
    addressid = json['address_id'];
    name = json['name'];
   
  }
}
