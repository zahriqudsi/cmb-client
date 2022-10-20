import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/InvoiceItemModel.dart';
import 'package:colombo_express_client/models/PackageHistoryModel.dart';
import 'package:colombo_express_client/models/PackagesModel.dart';
import 'package:colombo_express_client/models/PaymentsHistoryModel.dart';
import 'package:colombo_express_client/models/InvoiceModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_details.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final TokenModel authToken;
  const PaymentHistoryScreen({Key? key, required this.authToken})
      : super(key: key);

  @override
  _PaymentHistoryScreenState createState() =>
      _PaymentHistoryScreenState(authToken);
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  AppRepository appRepo = AppRepository(authToken: "");

  TokenModel authToken = TokenModel(token: "");

  _PaymentHistoryScreenState(TokenModel authTokenModel) {
    appRepo = AppRepository(authToken: authTokenModel.token);
    authToken = authTokenModel;
  }

  late PaymentsHistoryModel paymentHistory;
  late List<InvoiceModel> invoiceModel2;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    updatePaymentHistory();
  }

  updatePaymentHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      PaymentsHistoryModel response = await appRepo.paymentHistory();

      setState(() {
        paymentHistory = response;

        isLoading = false;
      });
    } catch (e) {
      print(e);
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    setState(() {
      print(height);
    });

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: loginHeaderColor,
            // image: DecorationImage(
            //   image: AssetImage(
            //     'assets/images/flight.jpg',
            //   ),
            //   fit: BoxFit.fill,
            // ),
          ),
        ),
        Scaffold(
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
                  'Payment History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              height: height * 1.1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double innerheight = constraints.maxHeight;
                  double innerwidth = constraints.maxWidth;
                  return Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 25,
                        child: Container(
                          height: innerheight * 1.5,
                          width: innerwidth,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(35.0),
                              topLeft: Radius.circular(35.0),
                            ),
                            color: kPrimaryBackgroungdColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 35.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ...List<Widget>.from(
                                //   paymentHistory.invoice.map(
                                //     (invoice) => _paymentCompleteCard(invoice),
                                //   ),
                                // ),

                                // Pagination(pages: ''),
                                !isLoading
                                    ? (paymentHistory.invoiceList.length > 0
                                        ? (paymentHistory.invoiceList.length > 2
                                            ? Column(
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    itemCount: paymentHistory
                                                        .invoiceList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return _paymentCompleteCard(
                                                        paymentHistory
                                                            .invoiceList[index],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: height * 0.79,
                                                child: Column(
                                                  children: [
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const ScrollPhysics(),
                                                      itemCount: paymentHistory
                                                          .invoiceList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return _paymentCompleteCard(
                                                          paymentHistory
                                                                  .invoiceList[
                                                              index],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        : Center(
                                            child: Container(
                                              height: height * 0.7,
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: const Text(
                                                "No payments have been made yet.",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF3a668b),
                                                ),
                                              ),
                                            ),
                                          ))
                                    : CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // bottomNavigationBar: _completeButton(),
        ),
      ],
    );
  }

  Widget _paymentCompleteCard(InvoiceModel invoiceModel) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentDetails(
              authToken: authToken,
              invoice: invoiceModel,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 2, bottom: 25),
        padding:
            const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        height: 160.0,
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
              offset: Offset(1, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ORDER #" + invoiceModel.package.trackingCode.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF999999),
                  ),
                ),
                Chip(
                  label: Text(
                    // "COMPLETED",
                    invoiceModel.currentStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  backgroundColor: chipColorB,
                  elevation: 3,
                  shadowColor: Colors.grey[60],
                  padding: const EdgeInsets.only(
                      left: 6.0, right: 6.0, top: 0, bottom: 0),
                ),
              ],
            ),
            Container(
              child: Text(
                "Package " +
                    invoiceModel.package.length.toString() +
                    "ft " +
                    invoiceModel.package.height.toString() +
                    "ft " +
                    invoiceModel.package.width.toString() +
                    "ft " +
                    invoiceModel.package.weight.toString() +
                    "kg",
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Robot',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF336699),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 19.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  // "\$40.00",
                  invoiceModel.currency + " " + invoiceModel.total,
                  style: const TextStyle(
                    fontSize: 19.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget _paymentPendingCard() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => PaymentDetail(
  //             authToken: authToken,
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(top: 2, bottom: 25),
  //       padding:
  //           const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
  //       height: 160.0,
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(10.0),
  //         ),
  //         boxShadow: [
  //           BoxShadow(
  //             color: kShadowColor,
  //             spreadRadius: 1,
  //             blurRadius: 10,
  //             offset: Offset(1, 2), // changes position of shadow
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 "ORDER #1652477854",
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontFamily: 'Roboto',
  //                   fontWeight: FontWeight.w500,
  //                   color: Color(0xFF999999),
  //                 ),
  //               ),
  //               Chip(
  //                 label: const Text(
  //                   "PENDING",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 12.5,
  //                     fontWeight: FontWeight.w600,
  //                     fontFamily: 'Roboto',
  //                   ),
  //                 ),
  //                 shape: const RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(5),
  //                     bottomLeft: Radius.circular(5),
  //                     topRight: Radius.circular(5),
  //                     bottomRight: Radius.circular(5),
  //                   ),
  //                 ),
  //                 backgroundColor: Colors.red,
  //                 elevation: 3,
  //                 shadowColor: Colors.grey[60],
  //                 padding: const EdgeInsets.only(
  //                     left: 6.0, right: 6.0, top: 0, bottom: 0),
  //               ),
  //             ],
  //           ),
  //           Container(
  //             child: const Text(
  //               "NY to CMB Shipment",
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 fontFamily: 'Robot',
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xFF336699),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 35,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: const [
  //               Text(
  //                 "Total Amount",
  //                 style: TextStyle(
  //                   fontSize: 19.5,
  //                   fontWeight: FontWeight.w500,
  //                   color: Color(0xFF999999),
  //                 ),
  //               ),
  //               Text(
  //                 "\$40.00",
  //                 style: TextStyle(
  //                   fontSize: 19.5,
  //                   fontWeight: FontWeight.w500,
  //                   color: Color(0xFF999999),
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
