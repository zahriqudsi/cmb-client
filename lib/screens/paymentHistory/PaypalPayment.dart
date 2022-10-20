import 'dart:core';
import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/models/PaymentPayModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:colombo_express_client/api/PaypalServices.dart';

class PaypalPayment extends StatefulWidget {
  final TokenModel authToken;
  final Function onFinish;
  final PaymentPayModel paymentinvoice;

  const PaypalPayment(
      {Key? key,
      required this.authToken,
      required this.onFinish,
      required this.paymentinvoice})
      : super(key: key);

  // PaypalPayment({required this.onFinish});

  @override
  PaypalPaymentState createState() => PaypalPaymentState(
      authToken: authToken, onFinish: onFinish, paymentinvoice: paymentinvoice);
}
// @override
// State<StatefulWidget> createState() {
//   return PaypalPaymentState();
// }

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TokenModel authToken;
  late final Function onFinish;
  AppRepository appRepo = AppRepository(authToken: "");
  final PaymentPayModel paymentinvoice;

  PaypalPaymentState(
      {required this.authToken,
      required this.onFinish,
      required this.paymentinvoice});

  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();

        final res =
            await services.createPaypalPayment(transactions, accessToken);
        print(res);

        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        // ignore: deprecated_member_use
        _scaffoldKey.currentState?.showSnackBar(snackBar);
      }
    });
  }

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;
  // item name, price and quantity
  String itemName = 'iPhone X';
  String itemPrice = '1.99';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    // List items = [
    //   {
    //     "name": itemName,
    //     "quantity": quantity,
    //     "price": itemPrice,
    //     "currency": defaultCurrency["currency"]
    //   }
    // ];

    List items = List.from(paymentinvoice.items.map((item) => {
          "name": item.description,
          "quantity": item.quantity,
          "price": item.price,
          "currency": paymentinvoice.currency
        }));

    // checkout invoice details
    String totalAmount = paymentinvoice.amount.toString();
    String subTotalAmount = paymentinvoice.amount.toString();
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'John';
    String userLastName = 'Doe';
    String addressCity = 'Colombo';
    String addressStreet = 'Galle Road';
    String addressZipCode = '110014';
    String addressCountry = 'Sri Lanka';
    String addressState = 'Western';
    String addressPhoneNumber = '+9477778889985';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];

              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => PaymentSuccessScreen(
                              authToken: authToken,
                              paymentinvoice: paymentinvoice,
                              transactionId: id.toString(),
                            )),
                  );
                });
              } else {
                // Navigator.of(context).pop();
                _showSnackBar(context, "Payment already completed.");
              }
            }
            if (request.url.contains(cancelURL)) {
              // Navigator.of(context).pop();
              _showSnackBar(context, "Payment cancelled.");
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
