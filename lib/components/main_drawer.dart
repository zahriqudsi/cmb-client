import 'package:colombo_express_client/models/ShipmentFromModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/auth/edit%20profile/edit_profile.dart';
import 'package:colombo_express_client/screens/auth/login/login_screen.dart';
import 'package:colombo_express_client/screens/dashboard/dashboard_screen.dart';
import 'package:colombo_express_client/screens/myAddress/myaddress_screen.dart';
import 'package:colombo_express_client/screens/myShipments/my_shipments.dart';
import 'package:colombo_express_client/screens/packageHistory/package_history_screen.dart';
import 'package:colombo_express_client/screens/paymentHistory/payment_history_screen.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20.0);
  final TokenModel authToken;

  const MainDrawer({Key? key, required this.authToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Drawer(
          child: Container(
            color: Colors.white,
            child: InkWell(
              child: ListView(
                shrinkWrap: true,
                padding: padding,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context, false),
                          icon: const Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: padding.add(
                      const EdgeInsets.symmetric(vertical: 40.0),
                    ),
                    // child: Image.asset(
                    //   'assets/images/ProjectYou_Logo_Horizontal_Sienna&Black.png',
                    //   height: 50,
                    //   width: 50,
                    // ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: 'Dashboard',
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const Divider(
                    color: Colors.blueGrey,
                    indent: 15,
                    endIndent: 15,
                  ),
                  buildMenuItem(
                    text: 'My Shipments',
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const Divider(
                    color: Colors.blueGrey,
                    indent: 15,
                    endIndent: 15,
                  ),
                  buildMenuItem(
                    text: 'Schedule a Pickup',
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const Divider(
                    color: Colors.blueGrey,
                    indent: 15,
                    endIndent: 15,
                  ),
                  buildMenuItem(
                    text: 'Payment History',
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const Divider(
                    color: Colors.blueGrey,
                    indent: 15,
                    endIndent: 15,
                  ),
                  buildMenuItem(
                    text: 'Package History',
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const Divider(
                    color: Colors.blueGrey,
                    indent: 15,
                    endIndent: 15,
                  ),
                  buildMenuItem(
                    text: 'My Address',
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const Divider(
                    color: Colors.blueGrey,
                    indent: 15,
                    endIndent: 15,
                  ),
                  buildMenuItem(
                    text: 'Edit Profile',
                    onClicked: () => selectedItem(context, 6),
                  ),
                  const Divider(
                    color: Colors.blueGrey,
                    indent: 15,
                    endIndent: 15,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  buildMenuItem(
                    text: 'Logout',
                    onClicked: () => selectedItem(context, 7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    // required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      // leading: Icon(
      //   icon,
      //   color: color,
      // ),
      title: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5a6d7d),
        ),
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(authToken: authToken),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyShipments(
              authToken: authToken,
              // shipmentId: shipmentId
            ),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Pickups(
              authToken: authToken,
            ),
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentHistoryScreen(
              authToken: authToken,
            ),
          ),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PackageHistoryScreen(
              authToken: authToken,
            ),
          ),
        );
        break;

      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyaddressScreen(authToken: authToken),
          ),
        );
        break;

      case 6:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfile(
              authToken: authToken,
              controller: TextEditingController(),
            ),
          ),
        );
        break;

      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              controller: TextEditingController(),
            ),
          ),
        );
        break;
    }
  }
}
