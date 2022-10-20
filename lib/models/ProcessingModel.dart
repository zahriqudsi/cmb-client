class ProcessingModel {
  int? currentPage;
  List<dynamic>? data;
  int? lastPage;

  ProcessingModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['data']['processing']['current_page'];
    data = json['data']['processing']['data'];
    lastPage = json['data']['processing']['last_page'];
  }
}
