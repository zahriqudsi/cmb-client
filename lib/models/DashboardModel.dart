import 'package:colombo_express_client/models/LinksModel.dart';
import 'package:colombo_express_client/models/ProcessingModel.dart';
import 'package:colombo_express_client/models/ShippedModel.dart';
import 'package:colombo_express_client/models/ToShippedModel.dart';

class DashboardModel {
  late String message;
  late List<ToShippedModel> data;
  int from = 0;
  int to = 0;
  int total = 0;

  DashboardModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = List<ToShippedModel>.from(
      json['data'].map(
        (toShippedData) => ToShippedModel.fromJson(toShippedData),
      ),
    );

    from = json['meta']['from'];
    to = json['meta']['to'];
    total = json['meta']['total'];
  }
}
