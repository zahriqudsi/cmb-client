class AddresssBookItemModel {
  late final int id;
  late final String label;
  late final String firstName;
  late final String lastName;
  late final String phone;
  late final String email;
  late final String address;
  late final String zipCode;
  late final String name;
  late final String fullAddress;
  late final int countryId;
  late final String countryName;
  late final int stateId;
  late final String stateName;
  late final int cityId;
  late final String cityName;

  AddresssBookItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    zipCode = json['zip_code'];
    name = json['name'];
    fullAddress = json['full_address'];
    countryId = json['country']['id'];
    countryName = json['country']['country'];
    stateId = json['state']['id'];
    stateName = json['state']['state'];
    cityId = json['city']['id'];
    cityName = json['city']['city'];
  }
}
