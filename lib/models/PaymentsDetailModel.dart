class PaymentsDetailModel{
  late int? id;
  String? invoiceDate;
  int? total;
  int? paymentmethodId;
  int? userId;
  String? currentStatus;
  int? invoiceid;



   PaymentsDetailModel.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      invoiceDate = json['invoice_date'];
      total = json['total'];
      paymentmethodId = json['payment_method_id'];
      userId = json['user_id'];
      currentStatus = json['current_status'];
      invoiceid =  json['status']['invoice_id'];

   }

}