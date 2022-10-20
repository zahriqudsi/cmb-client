class ShipmentFromModel {
  late int id;
  late String label;
  late String firstName;
  late String lastName;
  late String phone;
  late String email;
  late String address;
  late String zip;
  late String name;
  late String fullAddress;
  late String city;
  late String state;
  late String country;

  ShipmentFromModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    zip = json['zip_code'];
    name = json['name'];
    fullAddress = json['full_address'];
    city = json['city']['city'];
    state = json['state']['state'];
    country = json['country']['country'];
  }
}
