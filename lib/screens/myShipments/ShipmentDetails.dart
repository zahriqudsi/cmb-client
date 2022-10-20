import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/PaymentInfoModel.dart';
import 'package:colombo_express_client/models/SingleShipmentModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_summary_screen.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timelines/timelines.dart';

class ShipmentDetails extends StatefulWidget {
  final TokenModel authToken;
  final int shipmentId;

  const ShipmentDetails(
      {Key? key, required this.authToken, required this.shipmentId})
      : super(key: key);

  @override
  _ShipmentDetailsState createState() =>
      _ShipmentDetailsState(authToken: authToken, shipmentId: shipmentId);
}

class _ShipmentDetailsState extends State<ShipmentDetails> {
  final TokenModel authToken;
  final int shipmentId;
  AppRepository appRepo = AppRepository(authToken: "");

  _ShipmentDetailsState({required this.authToken, required this.shipmentId});

  String payStatus = "pending";
  bool isLoading = false;
  bool actionLoading = false;
  late SingleShipmentModel shipmentDetails;
  late List<PaymentInfoModel> payments;

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);

    loadShipmentDetails();
  }

  void loadShipmentDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      SingleShipmentModel sDetails =
          await appRepo.loadSingleShipment(shipmentId);

      setState(() {
        print(shipmentId);
        shipmentDetails = sDetails;
        payments = shipmentDetails.payments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      // extendBodyBehindAppBar: true,
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
              'Shipment Details',
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
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                              topRight: Radius.circular(35.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Package ID # " +
                                        shipmentDetails.trackingCode.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Chip(
                                    label: Text(
                                      shipmentDetails.status.status,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
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
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(0.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shipmentStatusContainer(),
                          const SizedBox(
                            height: 10,
                          ),
                          shipmentPackageContainer(),
                          const SizedBox(
                            height: 20,
                          ),
                          shipmentPackageStatus(),
                          const SizedBox(
                            height: 20,
                          ),
                          paymentStatus(),
                          const SizedBox(
                            height: 15,
                          ),
                          paymentDetailContainer(),
                        ],
                      )),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget shipmentStatusContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      height: 160.0,
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
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 20, left: 20),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 5, left: 20, bottom: 10),
            child: Text(
              "Package ID # " + shipmentDetails.trackingCode.toString(),
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
            thickness: 1,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: const Text(
                      "Sailing Date",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 5, left: 20),
                    child: Text(
                      shipmentDetails.sailingDate,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 10, right: 40),
                    child: const Text(
                      "Arrival Date",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 5, right: 40),
                    child: Text(
                      shipmentDetails.arrivalDate,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget shipmentPackageContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: const Text(
              "Package Details",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            height: 80.0,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              "Width",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              shipmentDetails.width.toString() + "ft",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF18598c),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VerticalDivider(
                        thickness: 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              "Height",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              shipmentDetails.height.toString() + "ft",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF18598c),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VerticalDivider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              "Length",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              shipmentDetails.length.toString() + "ft",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF18598c),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VerticalDivider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              "Weight",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              shipmentDetails.weight.toString() + "Kg",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF18598c),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shipmentPackageStatus() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      padding: const EdgeInsets.only(top: 10, left: 20, bottom: 30),
      height: 400.0,
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
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Package Status",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: forgotpasswodTextColor,
              ),
            ),
          ),
          shipmentDetails != null
              ? Container(
                  child: Expanded(
                    child: Timeline.tileBuilder(
                      theme: TimelineThemeData(
                        nodePosition: 0,
                        connectorTheme: const ConnectorThemeData(
                          thickness: 3.0,
                          color: Color(0xffd3d3d3),
                        ),
                        indicatorTheme: const IndicatorThemeData(
                          size: 15.0,
                        ),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 20.0),
                      builder: TimelineTileBuilder.connected(
                        contentsBuilder: (_, index) => _EmptyContents(
                          itemStaus: shipmentDetails.statusHistory[index],
                        ),
                        connectorBuilder: (_, index, __) {
                          if (index == 0) {
                            return const SolidLineConnector(
                                color: Color(0xffbac6cf));
                          } else {
                            return const SolidLineConnector();
                          }
                        },
                        indicatorBuilder: (_, index) {
                          if (shipmentDetails.statusHistory[index].status ==
                              shipmentDetails.status.status) {
                            return const OutlinedDotIndicator(
                              color: Color(0xff2e465a),
                              backgroundColor: Color(0xff2e465a),
                            );
                          } else {
                            return const OutlinedDotIndicator(
                              color: Color(0xffbac6cf),
                              borderWidth: 2.0,
                              backgroundColor: Color(0xffbac6cf),
                            );
                          }
                        },
                        itemExtentBuilder: (_, __) => kTileHeight,
                        itemCount: shipmentDetails.statusHistory.length,
                      ),
                    ),
                  ),
                )
              : Container(),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Shipped From",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: forgotpasswodTextColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              shipmentDetails.from.firstName +
                  " " +
                  shipmentDetails.from.lastName +
                  "\n" +
                  shipmentDetails.from.address +
                  ", " +
                  shipmentDetails.from.city +
                  " " +
                  shipmentDetails.from.state +
                  ", \n" +
                  shipmentDetails.from.zip +
                  "\n" +
                  shipmentDetails.from.country,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF999999),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Recived to",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: forgotpasswodTextColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              shipmentDetails.to.firstName +
                  " " +
                  shipmentDetails.to.lastName +
                  "\n" +
                  shipmentDetails.to.address +
                  ", " +
                  shipmentDetails.to.city +
                  " " +
                  shipmentDetails.to.state +
                  ", \n" +
                  shipmentDetails.to.zip +
                  "\n" +
                  shipmentDetails.to.country,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  top: 15,
                ),
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
              shipmentDetails.paymentStatus == "paid"
                  ? Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(
                          shipmentDetails.paymentStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
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
                        backgroundColor: Colors.green,
                        elevation: 6.0,
                        shadowColor: Colors.grey[60],
                        padding: const EdgeInsets.all(0.0),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(
                          shipmentDetails.paymentStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
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
                        backgroundColor: Colors.red,
                        elevation: 6.0,
                        shadowColor: Colors.grey[60],
                        padding: const EdgeInsets.all(0.0),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget paymentDetailContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
      alignment: Alignment.topLeft,
      height: 270.0,
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
              shipmentDetails.payments.map((payment) => Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payment.purposeInfo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                            color: const Color(0xFF333366),
                          ),
                        ),
                        Container(
                          child: Text(
                            'USD ' + payment.amount,
                            style: const TextStyle(
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
                  'USD ' + shipmentDetails.total.toString(),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: const Color(0xFF336699),
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
          // Container(
          //   child: shipmentDetails.paymentStatus == payStatus
          //       ? Container()
          //       : payNowButton(),
          // ),

          Container(
            child: shipmentDetails.hblStatus == true &&
                    shipmentDetails.paymentStatus ==
                        shipmentDetails.paymentStatus
                ? Container(
                    child: FlatButton(
                      minWidth: 315,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 50),
                      onPressed: null,
                      disabledColor: Colors.black12,
                      child: !actionLoading
                          ? const Text(
                              'Proceed to Pay',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Proxima',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const CircularProgressIndicator(),
                      color: loginbuttonColor,
                      shape: const StadiumBorder(),
                    ),
                  )
                :
                //     child: shipmentDetails.hblStatus == false ||
                //     shipmentDetails.paymentStatus == payStatus
                // ?
                Container(
                    child: FlatButton(
                      minWidth: 315,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 50),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaymentSummaryScreen(
                              authToken: authToken,
                              shipmentId: shipmentId,
                              // invoiceId: invoiceId,
                            ),
                          ),
                        );
                      },
                      child: !actionLoading
                          ? const Text(
                              'Proceed to Pay',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Proxima',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const CircularProgressIndicator(),
                      color: loginbuttonColor,
                      shape: const StadiumBorder(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget payNowButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentSummaryScreen(
              authToken: authToken,
              shipmentId: shipmentId,
              // invoiceId: invoiceId,
            ),
          ),
        );
      },
      child: const Text(
        'Pay Now',
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
}

const kTileHeight = 50.0;

class _EmptyContents extends StatelessWidget {
  SingleShipmentStatus itemStaus;

  _EmptyContents({required this.itemStaus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      // height: 10.0,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(2.0),
      //   color: const Color(0xffe6e7e9),
      // ),
      child: Text(itemStaus.status),
    );
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}
