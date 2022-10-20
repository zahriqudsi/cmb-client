import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/InvoiceItemModel.dart';
import 'package:colombo_express_client/models/PackageHistoryModel.dart';
import 'package:colombo_express_client/models/PackagesModel.dart';
import 'package:colombo_express_client/models/PaymentsHistoryModel.dart';
import 'package:colombo_express_client/models/InvoiceModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_history_screen.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PaymentDetails extends StatefulWidget {
  final TokenModel authToken;
  final InvoiceModel invoice;
  const PaymentDetails(
      {Key? key, required this.authToken, required this.invoice})
      : super(key: key);

  @override
  _PaymentDetailsState createState() =>
      _PaymentDetailsState(authToken: authToken, invoice: invoice);
}

class _PaymentDetailsState extends State<PaymentDetails> {
  AppRepository appRepo = AppRepository(authToken: "");
  final InvoiceModel invoice;

  TokenModel authToken = TokenModel(token: "");

  _PaymentDetailsState({required this.authToken, required this.invoice});

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);
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
          ),
        ),
        Scaffold(
          key: _scaffoldKey,

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AppBar(
                centerTitle: true,
                elevation: 0.0,
                automaticallyImplyLeading: true,
                title: const Text(
                  'Payment Details',
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
          // extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Container(
              height: height * 1.05,
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
                              top: 25.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _shipmentTitle(invoice)
                                // ...List<Widget>.from(
                                //   paymentHistory.invoiceList.map(
                                //     (invoice) => _shipmentTitle(invoice),
                                //   ),
                                // ),
                                // _shipmentTitle(),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                // _orderCard(),
                                // ...List<Widget>.from(
                                //     paymentHistory.invoiceList.map(
                                //   (invoice) => _orderCard(invoice),
                                // )),
                                // _paymentCard(),
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

  Widget _shipmentTitle(InvoiceModel invoiceModel) {
    final DateFormat formatter = DateFormat('dd MMM yyyy H:m');
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(10.0),
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Robot',
              color: Color(0xFF006699),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(top: 2, bottom: 25),
            padding:
                const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
            height: 170.0,
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
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order ID",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333366),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  invoiceModel.package.trackingCode.toString(),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF336699),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Payment Date",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333366),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  formatter.format(invoiceModel.invoiceDate),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF336699),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Payments",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(
                      invoiceModel.currentStatus,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
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
                    backgroundColor: const Color(0xFF33cc66),
                    elevation: 6.0,
                    shadowColor: Colors.grey[60],
                    padding: const EdgeInsets.all(0.0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
                alignment: Alignment.topLeft,
                height: 240.0,
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
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ...List<Widget>.from(
                        invoiceModel.items.map((invoiceItem) => Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    invoiceItem.description,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                      color: Color(0xFF333366),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      invoiceModel.currency +
                                          " " +
                                          invoiceItem.price,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            invoiceModel.currency + " " + invoiceModel.total,
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
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kShadowColor.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Download Invoice',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 0.0,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
