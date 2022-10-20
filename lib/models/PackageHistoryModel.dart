import 'PackagesModel.dart';
import 'ShipmentFromModel.dart';

class PackageHistoryModel {
  late String message;
  late List<PackagesModel> packages;
  int from = 0;
  int to = 0;
  int total = 0;

  PackageHistoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    packages = List<PackagesModel>.from(
        json['data'].map((detail) => PackagesModel.fromJson(detail)));
           from = json['meta']['from'];
    to = json['meta']['to'];
    total = json['meta']['total'];
  }
}
