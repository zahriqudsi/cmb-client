class ShipmentInformation {
  late int id;
  late int trackingCode;
  late int length;
  late int height;
  late int width;
  late int weight;
  late String arrivaldate;
  late String sailingdate;
  late String status;

  ShipmentInformation.fomJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingCode = json['tracking_code'];
    length = json['length'];
    height = json['height'];
    width = json['width'];
    weight = json['weight'];
    arrivaldate = json['arrival_date'];
    sailingdate = json['sailing_date'];
    status = json['status']['status'];
  }
}
