import 'package:colombo_express_client/models/InvoiceItemModel.dart';
import 'package:colombo_express_client/models/PackagesModel.dart';

class InvoiceModel {
  late final int id;
  late final DateTime invoiceDate;
  late final String total;
  late final String currentStatus;
  late final PackagesModel package;
  late final List<InvoiceItemModel> items;
  late final int amount;
  late final String currency;

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceDate = DateTime.parse(json['invoice_date']);
    total = json['total'];
    if (json['data'] != null) {
      package = PackagesModel.fromJson(json['data']['package']);
      items = List<InvoiceItemModel>.from(
        json['data']['items'].map(
          (item) => InvoiceItemModel.fromJson(item),
        ),
      );
      amount = json['data']['amount'];
      currency = json['data']['currency'];
    }

    currentStatus = json['current_status'];
  }
}
