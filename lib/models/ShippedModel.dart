class ShippedModel {
  int? currentPage;
  List<dynamic>? data;
  int? lastPage;

  ShippedModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['data']['shipped']['current_page'];
    data = json['data']['shipped']['data'];
    lastPage = json['data']['shipped']['last_page'];
  }
}
