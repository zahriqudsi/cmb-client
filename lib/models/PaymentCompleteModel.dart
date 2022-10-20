class PaymentCompleteModel {
  int? id;
  String? code;
  String? message;
  String? txnNumber;
  String? request;
  String? response;
  int? invoiceId;
  String? createdAt;
  String? updatedAt;

  // PaymentCompleteModel(
  //     {this.id,
  //     this.code,
  //     this.message,
  //     this.txnNumber,
  //     this.request,
  //     this.response,
  //     this.invoiceId,
  //     this.createdAt,
  //     this.updatedAt});

  PaymentCompleteModel.fromJson(Map<String, dynamic> json) {
    id = json['data']['id'];
    code = json['data']['code'];
    message = json['data']['message'];
    txnNumber = json['data']['txn_number'];
    request = json['data']['request'];
    response = json['data']['response'];
    invoiceId = json['data']['invoice_id'];
    createdAt = json['data']['created_at'];
    updatedAt = json['data']['updated_at'];
  }

  
}

