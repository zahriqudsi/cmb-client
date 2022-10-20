import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/PaymentInfoModel.dart';
import 'package:colombo_express_client/models/PaymentPayModel.dart';
import 'package:colombo_express_client/models/SingleShipmentModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_details.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_success_screen.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'PaypalPayment.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final TokenModel authToken;
  final int shipmentId;

  const PaymentSummaryScreen(
      {Key? key, required this.authToken, required this.shipmentId})
      : super(key: key);

  @override
  _PaymentSummaryScreenState createState() =>
      _PaymentSummaryScreenState(authToken: authToken, shipmentId: shipmentId);
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  final TokenModel authToken;
  final int shipmentId;
  AppRepository appRepo = AppRepository(authToken: "");

  _PaymentSummaryScreenState(
      {required this.authToken, required this.shipmentId});

  bool isLoading = false;

  // late SingleShipmentModel shipmentDetails;
  late PaymentPayModel paymentInformation;
  List<PaymentInfoModel>? payments;

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);
    loadPaymentinfo();
  }

  // void loadPaymentSummery() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     SingleShipmentModel sDetails =
  //         await appRepo.loadSingleShipment(shipmentId);

  //     setState(() {
  //       print(sDetails);
  //       shipmentDetails = sDetails;
  //       // payments = shipmentDetails.payments;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     print(e);
  //   }
  // }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loadPaymentinfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      PaymentPayModel pDetails = await appRepo.paymentPay(shipmentId, payments);

      setState(() {
        paymentInformation = pDetails;
        isLoading = false;
      });
    } catch (e, stacktrace) {
      _showSnackBar("Error retrieving your invoice");
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    setState(() {});

    return Scaffold(
      // extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      // drawer: MainDrawer(
      //   authToken: authToken,
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: AppBar(
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            title: const Text(
              'Payment Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      backgroundColor: loginHeaderColor,
      body: SafeArea(
        child: !isLoading
            ? ListView(
                children: [
                  Container(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 35.0,
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 25, right: 15, bottom: 25),
                                alignment: Alignment.topLeft,
                                height: 230.0,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kShadowColor,
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: Offset(
                                          1, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Package ID",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6e7682),
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "#" +
                                          paymentInformation
                                              .package.trackingCode
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF487ba5),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Divider(
                                    //   thickness: 1,
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Text(
                                    //   "Invoice to: ",
                                    //   style: TextStyle(
                                    //     color: Color(0xFFc5c5c5),
                                    //     fontWeight: FontWeight.w500,
                                    //     fontSize: 12.0,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Text(
                                    //   shipmentDetails.to.firstName +
                                    //       " " +
                                    //       shipmentDetails.to.lastName,
                                    //   style: TextStyle(
                                    //     fontSize: 18,
                                    //     fontWeight: FontWeight.w700,
                                    //     color: Color(0xFF487ca4),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // Text(
                                    //   shipmentDetails.to.address +
                                    //       ",\n" +
                                    //       shipmentDetails.to.city +
                                    //       ", " +
                                    //       shipmentDetails.to.state +
                                    //       ",\n" +
                                    //       shipmentDetails.to.zip +
                                    //       ", " +
                                    //       shipmentDetails.to.country,
                                    //   style: TextStyle(
                                    //     fontSize: 12.5,
                                    //     fontWeight: FontWeight.w700,
                                    //     color: Color(0xFF848a95),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // Text(
                                    //   "Alabam, 111100,United State of America",
                                    //   style: TextStyle(
                                    //     fontSize: 12.5,
                                    //     fontWeight: FontWeight.w700,
                                    //     color: Color(0xFF848a95),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 25, right: 15),
                                  alignment: Alignment.topLeft,
                                  height: 350.0,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: kShadowColor,
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: Offset(
                                            1, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ...List<Widget>.from(paymentInformation
                                          .items
                                          .map((info) => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      info.description,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'Roboto',
                                                        color:
                                                            Color(0xFF333366),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'USD ' + info.price,
                                                        style: TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Color(0xFF336699),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        // endIndent: 25,
                                        // indent: 25,
                                        thickness: 1,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Payable Total",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                              color: Color(0xFF333366),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'USD ' +
                                                  paymentInformation
                                                      .package.amount
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto',
                                                color: Color(0xFF336699),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        // endIndent: 25,
                                        // indent: 25,
                                        thickness: 1,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      _confirmpayButton(),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _confirmpayButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaypalPayment(
              authToken: authToken,
              paymentinvoice: paymentInformation,
              onFinish: (number) async {
                // payment done
                print('enabled button');

                print('order id: ' + number);
              },
            ),
          ),
        );
      },
      child: const Text(
        'Confirm Pay',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      color: loginbuttonColor,
      shape: const StadiumBorder(),
    );
  }

  // _fetchdetails() async{
  //   try{
  //     setLoading(true);
  //     await

  //   }

  // }
}
