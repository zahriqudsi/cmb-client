import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/components/pagination.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/DashboardModel.dart';
import 'package:colombo_express_client/models/PackageHistoryModel.dart';
import 'package:colombo_express_client/models/PackagesModel.dart';
import 'package:colombo_express_client/models/ToShippedModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/myShipments/ShipmentDetails.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PackageHistoryScreen extends StatefulWidget {
  final TokenModel authToken;

  const PackageHistoryScreen({Key? key, required this.authToken})
      : super(key: key);

  @override
  _PackageHistoryScreenState createState() =>
      _PackageHistoryScreenState(authToken);
}

class _PackageHistoryScreenState extends State<PackageHistoryScreen> {
  AppRepository appRepo = AppRepository(authToken: "");
  TokenModel authToken = TokenModel(token: "");
  _PackageHistoryScreenState(TokenModel authTokenModel) {
    appRepo = AppRepository(authToken: authTokenModel.token);
    authToken = authTokenModel;
  }

  // late DashboardModel packageHistory;

  late PackageHistoryModel packageHistoryModel;

  List<PackagesModel> packagesModel = [];

  // List<ToShippedModel> myPackageHistory = [];

  int packagePages = 1;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    updateDashboard(packagePages);
  }

  updateDashboard( int packagePages) async {
    setState(() {
      isLoading = true;
    });

    try {
      PackageHistoryModel response = await appRepo.packageHistory(packagePages);

      setState(() {
        print(response.packages);
        packageHistoryModel = response;
        packagesModel = packageHistoryModel.packages as List<PackagesModel>;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    setState(() {
      print(height);
    });

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
              'Package History',
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
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                            child: Column(
                              children: [
                                // Pagination(pages: ''),
                                !isLoading
                                    ? (packagesModel.length > 0
                                        ? (packagesModel.length > 2
                                            ? Column(
                                                children: [
                                                  Pagination(
                                          from: packageHistoryModel.from,
                                          to: packageHistoryModel.to,
                                          total: packageHistoryModel.total,
                                          onNext: () {
                                            setState(() {
                                              packagePages++;
                                            });

                                            updateDashboard(packagePages);
                                          },
                                          onPrev: () {
                                            setState(() {
                                              packagePages--;
                                            });

                                            updateDashboard(packagePages);
                                          },
                                        ),
                                                  // const Pagination(
                                                  //   pages: '',
                                                  // ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    itemCount:
                                                        packagesModel.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ShipmentItems(
                                                        packagesModel[index],
                                                        authToken,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: height * 0.79,
                                                child: Column(
                                                  children: [
                                                    // const Pagination(
                                                    //   pages: '',
                                                    // ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const ScrollPhysics(),
                                                      itemCount:
                                                          packagesModel.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ShipmentItems(
                                                          packagesModel[index],
                                                          authToken,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        : Center(
                                            child: Container(
                                              height: height * 0.78,
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: const Text(
                                                "Could not find any data.",
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
                      ],
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget ShipmentItems(PackagesModel packagesModel, TokenModel authToken) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShipmentDetails(
              authToken: authToken,
              shipmentId: packagesModel.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 2, left: 15, right: 15, bottom: 25),
        padding:
            const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        height: 200.0,
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
                  "# " + packagesModel.trackingCode.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFabb6bf),
                  ),
                ),
                Chip(
                  label: Text(
                    packagesModel.status.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
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
                  backgroundColor: chipColorA,
                  elevation: 3,
                  shadowColor: Colors.grey[60],
                  padding: const EdgeInsets.only(
                      left: 6.0, right: 6.0, top: 0, bottom: 0),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                "Package - " +
                    (packagesModel.length.toString()) +
                    "ft " +
                    (packagesModel.width.toString()) +
                    "ft " +
                    (packagesModel.height.toString()) +
                    "ft",
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF236192),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Sailing Date",
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        color: Color(0xFFb1bbc4),
                      ),
                    ),
                    Text(
                      "01 Dec 2021",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        color: Color(0xFF91a0ac),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 80),
                      child: const Text(
                        "Arrival Date",
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          color: Color(0xFFb1bbc4),
                        ),
                      ),
                    ),
                    const Text(
                      "15 Dec 2021",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        color: Color(0xFF91a0ac),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
