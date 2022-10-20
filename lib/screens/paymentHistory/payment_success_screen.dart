import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/PaymentPayModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/dashboard/dashboard_screen.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final TokenModel authToken;
  final PaymentPayModel paymentinvoice;
  final String transactionId;
  const PaymentSuccessScreen(
      {Key? key,
      required this.authToken,
      required this.paymentinvoice,
      required this.transactionId})
      : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState(
      authToken: authToken,
      paymentinvoice: paymentinvoice,
      transactionId: transactionId);
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  final TokenModel authToken;
  _PaymentSuccessScreenState(
      {required this.authToken,
      required this.paymentinvoice,
      required this.transactionId});
  AppRepository appRepo = AppRepository(authToken: "");
  final PaymentPayModel paymentinvoice;
  final String transactionId;

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);

    confirmPayment();
  }

  void confirmPayment() async {
    try {
      print({
        "invoice_id": paymentinvoice.invoiceId.toString(),
        "status": "approved",
        "transaction_id": transactionId,
        "payment_response": ""
      });

      bool result = await appRepo.paymentCompletion(paymentinvoice.package.id, {
        "invoice_id": paymentinvoice.invoiceId.toString(),
        "status": "approved",
        "transaction_id": transactionId,
        "payment_response": ""
      });

      if (result) {}
    } catch (e, stack) {
      _showSnackBar(context, "Error registering your payment");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;

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
          drawer: MainDrawer(
            authToken: authToken,
          ),
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
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    color: Colors.black,
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
              ),
            ),
          ),
          // extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Container(
              height: height * 0.87,
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
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 150.0,
                                    width: 150.0,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/checkmark.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Thank You.",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF66cc66),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Your payment for Colombo Express has been done successfully .",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Container(
                                    child: Text(
                                      "Transaction ref.\n" + transactionId,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  _viewInvoiceButton(),
                                ],
                              ),
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

  Widget _viewInvoiceButton() {
    return Container(
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
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        authToken: authToken,
                      )),
            );
          },
          child: const Text(
            'Return to Dashboard',
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
    );
  }
}
