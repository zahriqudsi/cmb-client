class PaymentPayModel {
  late Package package;
  late final List<Items> items;
  late int amount;
  late String currency;
  late int invoiceId;
  late String returnUrl;
  late String cancelUrl;

  PaymentPayModel.fromJson(Map<String, dynamic> json) {
    package = Package.fromJson(json['data']['payment']['package']);

    items = List<Items>.from(
      json['data']['payment']['items'].map(
        (itemsdata) => Items.fromJson(itemsdata),
      ),
    );
    amount = json['data']['payment']['amount'];
    currency = json['data']['payment']['currency'];
    invoiceId = json['data']['payment']['invoice_id'];
    returnUrl = json['data']['payment']['returnUrl'];
    cancelUrl = json['data']['payment']['cancelUrl'];
  }
}

class Package {
  late int id;
  late String pickupDate;
  late int trackingCode;
  late int length;
  late int height;
  late int width;
  late int weight;
  late String amount;
  late String dutyAmount;
  late String qrCode;
  late int from;
  late int to;
  late int delivery;
  late int duty;
  late int userId;
  late String createdAt;
  late String updatedAt;
  late Status status;
  late String qrCodeUrl;

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupDate = json['pickup_date'];
    trackingCode = json['tracking_code'];
    length = json['length'];
    height = json['height'];
    width = json['width'];
    weight = json['weight'];
    amount = json['amount'];
    dutyAmount = json['duty_amount'];
    qrCode = json['qr_code'];
    from = json['from'];
    to = json['to'];
    delivery = json['delivery'];
    duty = json['duty'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = Status.fromJson(json['status']);
    qrCodeUrl = json['qr_code_url'];
  }
}

class Status {
  late int id;
  late String status;
  late Pivot pivot;

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    pivot = Pivot.fromJson(json['pivot']);
  }
}

class Pivot {
  late int packageId;
  late int statusId;

  Pivot.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    statusId = json['status_id'];
  }
}

class Items {
  late String name;
  late String price;
  late String description;
  late int quantity;

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    description = json['description'];
    quantity = json['quantity'];
  }
}
