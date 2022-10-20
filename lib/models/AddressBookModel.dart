import 'package:colombo_express_client/models/AddresssBookItemModel.dart';

class AddressBookModel {
  late final List<AddresssBookItemModel> addresses;

  AddressBookModel.fromJson(Map<String, dynamic> json) {
    addresses = List<AddresssBookItemModel>.from(json['data']
        .map((addressItem) => AddresssBookItemModel.fromJson(addressItem)));
  }
}
