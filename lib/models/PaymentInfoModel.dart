class PaymentInfoModel {
  late final int id;
  late final int packageid;
  late final int invoiceid;
  late final String amount;
  late final String purposeInfo;

  PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageid = json['package_id'];
    invoiceid = json['invoice_id'];
    amount = json['amount'];
    purposeInfo = json['purpose_info'];
  }
}
