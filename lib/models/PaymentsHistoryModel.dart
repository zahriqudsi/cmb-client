import 'package:colombo_express_client/models/InvoiceModel.dart';
import 'package:colombo_express_client/models/PackagesModel.dart';
import 'package:colombo_express_client/models/PaymentsModel.dart';

class PaymentsHistoryModel {
  String? message;
  late final List<InvoiceModel> invoiceList;

  PaymentsHistoryModel({this.message});

  PaymentsHistoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    invoiceList = List<InvoiceModel>.from(
      json['data']['payments']['data'].map(
        (paymentModel) => InvoiceModel.fromJson(paymentModel),
      ),
    );
  }
}
