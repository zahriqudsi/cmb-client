import 'package:colombo_express_client/models/ShipmentInformation.dart';

class MyShipmentsModel {
  late String message;
  late final List<ShipmentInformation> details;
  int from = 0;
  int to = 0;
  int total = 0;

  MyShipmentsModel.fomJson(Map<String, dynamic> json) {
    message = json['message'];
    details = List<ShipmentInformation>.from(
        json['data'].map((detail) => ShipmentInformation.fomJson(detail)));
    from = json['meta']['from'];
    to = json['meta']['to'];
    total = json['meta']['total'];
  }
}
