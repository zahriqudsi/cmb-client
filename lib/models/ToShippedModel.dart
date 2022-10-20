import 'package:colombo_express_client/models/PaymentInfoModel.dart';
import 'package:colombo_express_client/models/ShipmentFromModel.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_details.dart';

class ToShippedModel {
  late int id;
  late DateTime pickupDate;
  int? trackingCode;
  int? length;
  int? height;
  int? width;
  int? weight;
  late ShipmentFromModel from;
  late final List<PaymentInfoModel> payments;
  late bool hblStatus;
  late String paymentStatus;
  String? status;

  ToShippedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupDate = DateTime.parse(json['pickup_date']);
    trackingCode = json['tracking_code'];
    length = json['length'];
    height = json['height'];
    width = json['width'];
    weight = json['weight'];
    from = ShipmentFromModel.fromJson(json['from']);
    payments = List<PaymentInfoModel>.from(
      json['payment'].map(
        (payment) => PaymentInfoModel.fromJson(payment),
      ),
    );
    hblStatus = json['hbl_status'];
    paymentStatus = json['payment_status'];
    status = json['status']['status'];
  }
}
