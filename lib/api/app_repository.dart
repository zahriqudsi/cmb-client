import 'dart:io';
import 'package:colombo_express_client/models/AddressBookModel.dart';
import 'package:colombo_express_client/models/AddressModel.dart';
import 'package:colombo_express_client/models/CityModel.dart';
import 'package:colombo_express_client/models/CountryModel.dart';
import 'package:colombo_express_client/models/DashboardModel.dart';
import 'package:colombo_express_client/models/InvoiceModel.dart';
import 'package:colombo_express_client/models/MyShipmentsModel.dart';
import 'package:colombo_express_client/models/PackageHistoryModel.dart';
import 'package:colombo_express_client/models/PaymentsModel.dart';
import 'package:colombo_express_client/models/PaymentsHistoryModel.dart';
import 'package:colombo_express_client/models/SingleShipmentModel.dart';
import 'package:colombo_express_client/models/StateModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/models/UserModel.dart';
import 'package:colombo_express_client/models/ValidateUserModel.dart';
import 'package:colombo_express_client/models/PaymentPayModel.dart';
import 'package:colombo_express_client/util/network_util.dart';

class AppRepository {
  final String authToken;
  dynamic headers;

  AppRepository({required this.authToken}) {
    headers = {
      // HttpHeaders.acceptHeader: "application/json",
      // HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer ' + authToken
    };
  }

  NetworkUtil net = NetworkUtil();

  Future<TokenModel> login(dynamic body) async {
    return net.post('api/customer/login', body: body).then((dynamic res) async {
      if (res != null) {
        return TokenModel.fromJson(res['data']);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<DashboardModel> dashboardShipped(int page) async {
    return net.get('api/customer/dashboard',
        headers: headers,
        body: {'page': page.toString()}).then((dynamic res) async {
      if (res != null) {
        return DashboardModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<DashboardModel> dashboardProcessing(int page) async {
    return net.get('api/customer/dashboard/processing',
        headers: headers,
        body: {'page': page.toString()}).then((dynamic res) async {
      if (res != null) {
        return DashboardModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<DashboardModel> dashboardToShipped(int page) async {
    return net.get('api/customer/dashboard/to-ship',
        headers: headers,
        body: {'page': page.toString()}).then((dynamic res) async {
      if (res != null) {
        return DashboardModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<PaymentsHistoryModel> paymentHistory() async {
    return net
        .get('api/customer/payments-history', headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return PaymentsHistoryModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      print(e);
      throw e;
    });
  }

  Future<PackageHistoryModel> packageHistory(int page) async {
    return net
        .get('api/customer/package-history', headers: headers,
          body: {'page': page.toString()})
        .then((dynamic res) async {
      if (res != null) {
        return PackageHistoryModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  // Future<PaymentsHistoryModel> paymentDetails() async {
  //   return net
  //       .get('api/customer/payments-history', headers: headers)
  //       .then((dynamic res) async {
  //     if (res != null) {
  //       return PaymentsHistoryModel.fromJson(res);
  //     } else {
  //       throw Exception("Error loading data");
  //     }
  //   }).catchError((e) {
  //     print(e);
  //     throw e;
  //   });
  // }

  Future<MyShipmentsModel> myShipments(int page) async {
    return net
        .get('api/customer/my-shipments', headers: headers,
        body: {'page': page.toString()})
        .then((dynamic res) async {
      if (res != null) {
        return MyShipmentsModel.fomJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<SingleShipmentModel> loadSingleShipment(int shipmentId) async {
    return net
        .get('api/customer/my-shipments/' + shipmentId.toString(),
            headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return SingleShipmentModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  // Future<SingleShipmentModel> singleShipment(int shipmentId) async {
  //   return net
  //       .get('api/customer/my-shipments/' + shipmentId.toString(),
  //           headers: headers)
  //       .then((dynamic res) async {
  //     if (res != null) {
  //       return SingleShipmentModel.fromJson(res);
  //     } else {
  //       throw Exception("Error loading data");
  //     }
  //   }).catchError((e) {
  //     throw e;
  //   });
  // }

  Future<bool> forgotPassword(dynamic data) async {
    return net
        .post('api/customer/forgot-password', body: data, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return true;
        }
        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> sendVerifyEmail(String email) async {
    return net
        .get('api/customer/send-verification-email/' + email)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return true;
        }
        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<AddressModel> addAddress() async {
    return net
        .post('api/customer/my-addresses/create', headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return AddressModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<ValidateUserModel> validateUser(dynamic body) async {
    return net
        .post('api/customer/validate-user', body: body)
        .then((dynamic response) async {
      if (response != null) {
        return ValidateUserModel.fromJson(response['data']);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> insertUser(dynamic body) async {
    return net
        .post('api/customer/register', body: body)
        .then((dynamic response) async {
      if (response != null) {
        if (response['code'] == 200) {
          return true;
        }

        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> schedulePickup(dynamic body) async {
    return net
        .post('api/customer/schedule-pickup', body: body, headers: headers)
        .then((dynamic response) async {
      if (response != null) {
        if (response['code'] == 200) {
          return true;
        }

        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> updatePassword(dynamic body) async {
    return net
        .post('api/customer/profile/password/update',
            headers: headers, body: body)
        .then((dynamic response) async {
      if (response != null) {
        if (response['code'] == 200) {
          return true;
        }

        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<CountryModel>> getCountries() async {
    return net.get('api/countries', headers: headers).then((dynamic res) async {
      if (res != null) {
        return List<CountryModel>.from(res['data']['countries']
            .map((country) => CountryModel.fromJson(country)));
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<StateModel>> getState(String countryid) async {
    return net
        .get('api/country/' + countryid + '/states', headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return List<StateModel>.from(
            res['data']['states'].map((state) => StateModel.fromJson(state)));
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<CityModel>> getCities(String stateid) async {
    return net
        .get('api/state/' + stateid + '/cities', headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return List<CityModel>.from(
            res['data']['states'].map((city) => CityModel.fromJson(city)));
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<UserModel> getUser() async {
    return net
        .get('api/customer/profile', headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return UserModel.fromJson(res['data']['user']);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<UserModel> updateProfile(dynamic data) async {
    return net
        .post('api/customer/profile/update', body: data, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return UserModel.fromJson(res['data']['user']);
        }
        return UserModel.fromJson(res['data']['user']);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  // Address Manangement

  Future<AddressBookModel> getAddresses() async {
    return net
        .get('api/customer/my-addresses', headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return AddressBookModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> crateAddress(dynamic data) async {
    return net
        .post('api/customer/my-addresses/create', body: data, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return true;
        }
        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> updateAddress(int addressId, dynamic data) async {
    return net
        .post('api/customer/my-addresses/' + addressId.toString() + '/update',
            body: data, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return true;
        }
        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> deleteAddress(int addressId) async {
    return net
        .get('api/customer/my-addresses/' + addressId.toString() + '/remove',
            headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return true;
        }
        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> paymentCompletion(int shipmentid, dynamic data) async {
    return net
        .post('api/customer/package/' + shipmentid.toString() + '/confirm',
            body: data, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return true;
        }
        return false;
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<PaymentPayModel> paymentPay(int shipmentid, dynamic data) async {
    return net
        .post('api/customer/package/' + shipmentid.toString() + '/pay',
            body: data, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['code'] == 200) {
          return PaymentPayModel.fromJson(res);
        }
        return PaymentPayModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }
}
