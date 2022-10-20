import 'PaymentsDetailModel.dart';

class PaymentsModel {
  int? currentPage;
  List<PaymentsDetailModel>? paymentDetails;
  int? from;
  int? to;
  int? total;

 
  PaymentsModel({this.from, this.to, this.total,this.currentPage});

  PaymentsModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['data']['payments']['current_page'];
    from = json['data']['payments']['from'];
    to = json['data']['payments']['to'];
    total = json['data']['payments']['total'];

    paymentDetails = List<PaymentsDetailModel>.from(
      json['data']['payments']['data'].map(
        (paymentData) => PaymentsDetailModel.fromJson(paymentData),
      ),
    );

   
  }
}
