class PackagesModel {
  late final int id;
  late final String pickupDate;
  late final int trackingCode;
  late final int length;
  late final int height;
  late final int width;
  late final int weight;
  late final String amount;
  late final String dutyAmount;
  late final String status;

  PackagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupDate = json['pickup_date'];
    trackingCode = json['tracking_code'];
    length = json['length'];
    height = json['height'];
    width = json['width'];
    weight = json['weight'];
    amount = json['amount'];
    dutyAmount = json['duty_amount'];
    if (json['status'] != null) {
      status = json['status']['status'];
    }
  }
}
