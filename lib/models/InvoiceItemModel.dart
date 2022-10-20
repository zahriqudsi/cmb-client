class InvoiceItemModel {
  late final String name;
  late final String price;
  late final String description;
  late final int qty;

  InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    description = json['description'];
    qty = json['quantity'];
  }
}
