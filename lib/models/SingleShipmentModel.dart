import 'package:colombo_express_client/models/PaymentInfoModel.dart';
import 'package:colombo_express_client/models/ShipmentFromModel.dart';

class SingleShipmentModel {
  late int id;
  late int trackingCode;
  late int length;
  late int width;
  late int height;
  late int weight;
  late String amount;
  late String sailingDate;
  late String arrivalDate;
  late String dutyAmount;
  late String total;
  late String qrImage;
  late ShipmentFromModel from;
  late ShipmentFromModel to;
  late SingleShipmentStatus status;
  late final List<PaymentInfoModel> payments;
  late String paymentStatus;
  late bool hblStatus;
  late final List<SingleShipmentStatus> statusHistory;

  SingleShipmentModel.fromJson(Map<String, dynamic> json) {
    id = json['data']['shipment']['id'];
    trackingCode = json['data']['shipment']['tracking_code'];
    length = json['data']['shipment']['length'];
    width = json['data']['shipment']['width'];
    height = json['data']['shipment']['height'];
    weight = json['data']['shipment']['weight'];
    status = SingleShipmentStatus.fromJson(
        json['data']['shipment']['current_status']);
    from = ShipmentFromModel.fromJson(json['data']['shipment']['from']);
    to = ShipmentFromModel.fromJson(json['data']['shipment']['to']);
    amount = json['data']['shipment']['amount'];
    sailingDate = json['data']['shipment']['sailing_date'];
    arrivalDate = json['data']['shipment']['arrival_date'];

    // if (json['data']['shipment']['sailing_date'] != null) {
    //   arrivalDate = DateTime.parse(json['data']['shipment']['sailing_date']);
    // }
    dutyAmount = json['data']['shipment']['duty_amount'];
    total = json['data']['shipment']['total'];
    payments = List<PaymentInfoModel>.from(
      json['data']['shipment']['payment'].map(
        (payment) => PaymentInfoModel.fromJson(payment),
      ),
    );
    paymentStatus = json['data']['shipment']['payment_status'];
    hblStatus = json['data']['shipment']['hbl_status'];
    statusHistory = List<SingleShipmentStatus>.from(
      json['data']['shipment']['status_history'].map(
        (payment) => SingleShipmentStatus.fromJson(payment),
      ),
    );
  }
}

class SingleShipmentStatus {
  late final int id;
  late final String status;

  SingleShipmentStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
  }
}
