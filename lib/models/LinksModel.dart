class LinksModel {
  late Null url;
  late String lable;
  late bool active;

  LinksModel.fromJson(Map<String, dynamic> json) {
    url = json['data']['to_ship']['url'];
    lable = json['data']['to_ship']['label'];
    active = json['data']['to_ship']['active'];
  }
}
