import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/components/pagination.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/DashboardModel.dart';
import 'package:colombo_express_client/models/LinksModel.dart';
import 'package:colombo_express_client/models/ToShippedModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/myShipments/ShipmentDetails.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_summary_screen.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardScreen extends StatefulWidget {
  final TokenModel authToken;

  const DashboardScreen({Key? key, required this.authToken}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState(this.authToken);
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  AppRepository appRepo = AppRepository(authToken: "");

  TokenModel authToken = TokenModel(token: "");

  _DashboardScreenState(TokenModel authTokenModel) {
    appRepo = AppRepository(authToken: authTokenModel.token);
    authToken = authTokenModel;
  }

  late DashboardModel dashboardToShipped;
  late DashboardModel processingDash;
  late DashboardModel shippedDash;

  List<ToShippedModel> toBeShipped = [];
  List<ToShippedModel> processing = [];
  List<ToShippedModel> shipped = [];

  int toShippedPage = 1;
  int processingPage = 1;
  int shippedPage = 1;

  // late List<LinksModel> pageLinks;

  // List<ProcessingModel> processing = [];
  // List<ShippedModel> shipped = [];

  bool isLoading = false;
  bool actionLoading = false;

  TabController? _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController!.index;
        });
        if (_tabController!.index == 0) {
          updateDashboardtoShipped(toShippedPage);
        }
        if (_tabController!.index == 1) {
          updateDashboardProcessing(processingPage);
        }
        if (_tabController!.index == 2) {
          updateDashboard(shippedPage);
        }
      }
    });
    updateDashboardtoShipped(toShippedPage);
    updateDashboardProcessing(processingPage);
    updateDashboard(shippedPage);
  }

  updateDashboard(int shippedPage) async {
    setState(() {
      isLoading = true;
    });

    try {
      DashboardModel response = await appRepo.dashboardShipped(shippedPage);

      setState(() {
        // print(response.firstPageURL);
        shippedDash = response;
        shipped = shippedDash.data as List<ToShippedModel>;
        // pageLinks = dashboardToShipped.links as List<LinksModel>;
        isLoading = false;
      });
    } catch (e, stacktrace) {
      setState(() {
        isLoading = false;
      });
      print(stacktrace);
    }
  }

  updateDashboardProcessing(int processingPage) async {
    setState(() {
      isLoading = true;
    });

    try {
      DashboardModel response =
          await appRepo.dashboardProcessing(processingPage);

      setState(() {
        // print(response.firstPageURL);
        processingDash = response;
        processing = processingDash.data as List<ToShippedModel>;
        // pageLinks = dashboardToShipped.links as List<LinksModel>;
        isLoading = false;
      });
    } catch (e, stacktrace) {
      setState(() {
        isLoading = false;
      });
      print(stacktrace);
    }
  }

  updateDashboardtoShipped(int toShippedPage) async {
    setState(() {
      isLoading = true;
    });

    try {
      DashboardModel response = await appRepo.dashboardToShipped(toShippedPage);

      setState(() {
        // print(response.firstPageURL);
        dashboardToShipped = response;
        toBeShipped = dashboardToShipped.data as List<ToShippedModel>;
        // pageLinks = dashboardToShipped.links as List<LinksModel>;
        isLoading = false;
      });
    } catch (e, stacktrace) {
      setState(() {
        isLoading = false;
      });
      print(stacktrace);
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    double height = MediaQuery.of(context).size.height;
    setState(() {
      print(height);
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: loginHeaderColor,
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
              'Dashboard',
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Pickups(
                          authToken: authToken,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    child: SvgPicture.asset(
                      "assets/images/plus.svg",
                      color: Colors.white,
                      width: 20,
                    ),
                    radius: 22,
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: !isLoading
            ? ListView(
                children: [
                  Container(
                    height: 10,
                  ),
                  Container(
                    // height: 0.5 * height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          labelColor: const Color(0xFF3a668b),
                          unselectedLabelColor: const Color(0xFFc5cfd8),
                          indicatorColor: const Color(0xFF3a668b),
                          indicatorWeight: 4,
                          indicatorSize: TabBarIndicatorSize.label,
                          enableFeedback: true,
                          padding: const EdgeInsets.all(5.0),
                          labelPadding: const EdgeInsets.all(0),
                          controller: _tabController,
                          tabs: [
                            Tab(
                              height: 35,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 15, left: 8.0, right: 8.0),
                                    child: Text('TO BE SHIPPED'),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              height: 35,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 15, left: 8.0, right: 8.0),
                                    child: Text('PROCESSING'),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              height: 35,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 15, left: 8.0, right: 8.0),
                                    child: Text('SHIPPED'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: [
                            !isLoading
                                ? (toBeShipped.length > 0
                                    ? (toBeShipped.length > 2
                                        ? Column(
                                            children: [
                                              Pagination(
                                                from: dashboardToShipped.from,
                                                to: dashboardToShipped.to,
                                                total: dashboardToShipped.total,
                                                onNext: () {
                                                  setState(() {
                                                    toShippedPage++;
                                                  });

                                                  updateDashboardtoShipped(
                                                      toShippedPage);
                                                },
                                                onPrev: () {
                                                  setState(() {
                                                    toShippedPage--;
                                                  });

                                                  updateDashboardtoShipped(
                                                      toShippedPage);
                                                },
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemCount: toBeShipped.length,
                                                itemBuilder: (context, index) {
                                                  return shipmentItems(
                                                    toBeShipped[index],
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
                                                Pagination(
                                                  from: dashboardToShipped.from,
                                                  to: dashboardToShipped.to,
                                                  total:
                                                      dashboardToShipped.total,
                                                  onNext: () {
                                                    setState(() {
                                                      toShippedPage++;
                                                    });

                                                    updateDashboardtoShipped(
                                                        toShippedPage);
                                                  },
                                                  onPrev: () {
                                                    setState(() {
                                                      toShippedPage--;
                                                    });

                                                    updateDashboardtoShipped(
                                                        toShippedPage);
                                                  },
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const ScrollPhysics(),
                                                  itemCount: toBeShipped.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return shipmentItems(
                                                      toBeShipped[index],
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
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: const Text(
                                            "No packages have been scheduled yet",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF3a668b),
                                            ),
                                          ),
                                        ),
                                      ))
                                : const CircularProgressIndicator(),
                            !isLoading
                                ? (processing.length > 0
                                    ? (processing.length > 2
                                        ? Column(
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemCount: processing.length,
                                                itemBuilder: (context, index) {
                                                  return shipmentItems(
                                                    processing[index],
                                                    authToken,
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: height * 0.76,
                                            child: Column(
                                              children: [
                                                Pagination(
                                                  from: processingDash.from,
                                                  to: processingDash.to,
                                                  total: processingDash.total,
                                                  onNext: () {
                                                    setState(() {
                                                      processingPage++;
                                                    });

                                                    updateDashboardProcessing(
                                                        processingPage);
                                                  },
                                                  onPrev: () {
                                                    setState(() {
                                                      processingPage--;
                                                    });

                                                    updateDashboardProcessing(
                                                        toShippedPage);
                                                  },
                                                ),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    itemCount:
                                                        processing.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return shipmentItems(
                                                        processing[index],
                                                        authToken,
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ))
                                    : Center(
                                        child: Container(
                                          height: height * 0.78,
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: const Text(
                                            "No packages have been scheduled yet",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF3a668b),
                                            ),
                                          ),
                                        ),
                                      ))
                                : const CircularProgressIndicator(),
                            !isLoading
                                ? (shipped.length > 0
                                    ? (shipped.length > 2
                                        ? Column(
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemCount: shipped.length,
                                                itemBuilder: (context, index) {
                                                  return shipmentItems(
                                                    shipped[index],
                                                    authToken,
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: height * 0.76,
                                            child: Column(
                                              children: [
                                                Pagination(
                                                    from: shippedDash.from,
                                                    to: shippedDash.to,
                                                    total: shippedDash.total,
                                                    onNext: () {
                                                      setState(() {
                                                        shippedPage++;
                                                      });
                                                      updateDashboard(
                                                          shippedPage);
                                                    },
                                                    onPrev: () {
                                                      setState(() {
                                                        shippedPage--;
                                                      });

                                                      updateDashboard(
                                                          shippedPage);
                                                    }),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    itemCount: shipped.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return shipmentItems(
                                                        shipped[index],
                                                        authToken,
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ))
                                    : Center(
                                        child: Container(
                                          height: height * 0.78,
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: const Text(
                                            "No packages have been scheduled yet",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF3a668b),
                                            ),
                                          ),
                                        ),
                                      ))
                                : const CircularProgressIndicator(),
                          ][_tabController!.index],
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

  Widget shipmentItems(ToShippedModel toShipped, TokenModel authToken) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShipmentDetails(
              authToken: authToken,
              shipmentId: toShipped.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 25,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        padding: const EdgeInsets.only(
          top: 10,
          left: 15,
          right: 15,
          bottom: 10,
        ),
        height: 170.0,
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
                  "ID " + toShipped.trackingCode.toString(),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF646c79),
                  ),
                ),
                Chip(
                  label: Text(
                    toShipped.status.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
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
                  backgroundColor: chipColorA,
                  elevation: 3,
                  shadowColor: Colors.grey[60],
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 0, bottom: 0),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              child: Text(
                "Package - " +
                    (toShipped.length.toString()) +
                    "ft " +
                    (toShipped.height.toString()) +
                    "ft " +
                    (toShipped.width.toString()) +
                    "ft " +
                    (toShipped.weight.toString()) +
                    "kg",
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2a6695),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toShipped.from.label +
                          "\n" +
                          toShipped.from.address +
                          ", " +
                          toShipped.from.city +
                          ", " +
                          toShipped.from.state +
                          ",\n" +
                          toShipped.from.zip +
                          ", " +
                          toShipped.from.country,
                      style: const TextStyle(
                        color: const Color(
                          0xFFadb8c1,
                        ),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    toShipped.hblStatus == true &&
                            toShipped.paymentStatus == toShipped.paymentStatus
                        ? Container()
                        : Container(
                            child: InkWell(
                              onTap: () {
                                print("Tapped me");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PaymentSummaryScreen(
                                      authToken: authToken,
                                      shipmentId: toShipped.id,
                                      // invoiceId: invoiceId,
                                    ),
                                  ),
                                );
                              },
                              child: Chip(
                                label: const Text(
                                  "Proceed to pay",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                backgroundColor: chipColorA,
                                elevation: 3,
                                shadowColor: Colors.grey[60],
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 0, bottom: 0),
                              ),
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
