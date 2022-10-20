import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PickupRequestSuccess extends StatefulWidget {
  final TokenModel authToken;
  const PickupRequestSuccess({Key? key, required this.authToken}) : super(key: key);

  @override
  State<PickupRequestSuccess> createState() => _PickupRequestSuccessState(authToken: authToken);
}

class _PickupRequestSuccessState extends State<PickupRequestSuccess> {
  final TokenModel authToken;
  _PickupRequestSuccessState({required this.authToken});
  AppRepository appRepo = AppRepository(authToken: "");
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
          drawer:  MainDrawer(
            authToken : authToken
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
                                      "Pickup request has been added",
                                      style: TextStyle(
                                        fontSize: 22,
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
                                      "Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet",
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
                                  _backToDasboardButton(),
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

  Widget _backToDasboardButton() {
    return Container(
      height: 60,
      width: 220,
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
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DashboardScreen(),
            //   ),
            // );
          },
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
              ),
              const Text(
                'Back to Dashboard',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.0,
                  color: Color(0xFF646a73),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
