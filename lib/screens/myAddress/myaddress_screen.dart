import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/AddressBookModel.dart';
import 'package:colombo_express_client/models/AddresssBookItemModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/myAddress/addAddress.dart';
import 'package:colombo_express_client/screens/myAddress/editAddress.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyaddressScreen extends StatefulWidget {
  final TokenModel authToken;
  Function? callback;

  MyaddressScreen({Key? key, required this.authToken, this.callback})
      : super(key: key);

  @override
  _MyaddressScreenState createState() =>
      _MyaddressScreenState(authToken: authToken, callback: this.callback);
}

class _MyaddressScreenState extends State<MyaddressScreen> {
  AppRepository appRepo = AppRepository(authToken: "");
  TokenModel authToken;
  Function? callback;

  _MyaddressScreenState({required this.authToken, this.callback});

  late AddressBookModel addressBook;
  List<AddresssBookItemModel> myAddressList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);

    updateAddressBook();
  }

  updateAddressBook() async {
    setState(() {
      isLoading = true;
    });

    try {
      AddressBookModel response = await appRepo.getAddresses();

      setState(() {
        addressBook = response;
        myAddressList = addressBook.addresses as List<AddresssBookItemModel>;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void deleteAddress(int addressId) async {
    try {
      setState(() {
        isLoading = true;
      });

      bool status = await appRepo.deleteAddress(addressId);

      setState(() {
        isLoading = false;
      });

      if (status) {
        _showSnackBar("Address deleted");
        updateAddressBook();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("Error deleting address");
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: AppBar(
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            title: const Text(
              'My Address',
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
      body: SafeArea(
        child: ListView(
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
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 35.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.from(
                      myAddressList.map(
                        (addressItem) => _addressCard(addressItem),
                      ),
                    ),
                    _addAddressButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    //_defauldAddressCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defauldAddressCard() {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 25),
      height: 165.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1c6095),
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
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: const Text(
                "DEFAULT ADDRESS",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
              backgroundColor: chipColorB,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              // padding: const EdgeInsets.all(6.0),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: const Text(
                "Jhon Doe",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: const Text(
                "725 Yourk Street Burmingham,",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8.0, left: 10),
              child: const Text(
                "Alabam, 111100,United State of America",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressCard(AddresssBookItemModel addressItem) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 25),
      height: 200.0,
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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 10,
                  ),
                  child: Text(
                    addressItem.label,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFcccccc)),
                  ),
                ),
                // ],
                // ),
                callback == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditAddress(
                                      authToken: authToken,
                                      addressItem: addressItem),
                                ),
                              );
                            },
                            child: Text("Edit"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              deleteAddress(addressItem.id);
                            },
                            child: Text("Delete"),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              callback!(addressItem);
                            },
                            child: Text("Select"),
                          )
                        ],
                      ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: Text(
                addressItem.firstName + " " + addressItem.lastName,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF336699),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                addressItem.fullAddress,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _officeAddressCard() {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 25),
      height: 180.0,
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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 10,
                  ),
                  child: const Text(
                    "My Office",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFcccccc)),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 10, right: 15, bottom: 10, left: 15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kShadowColor,
                            // spreadRadius: 1,
                            blurRadius: 5,
                            // offset: Offset(0, 1),
                          ),
                        ]),
                    child: const Text(
                      "Edit Address",
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFcccccc),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: const Text(
                "Jhon Doe",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF336699),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: const Text(
                "725 Yourk Street Burmingham,",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF999999),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8.0, left: 10),
              child: const Text(
                "Alabam, 111100,United State of America",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseAddressButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const DashboardScreen(),
        //   ),
        // );
      },
      child: const Text(
        'Choose Address',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      color: Colors.blueAccent,
      shape: const StadiumBorder(),
    );
  }

  Widget _addAddressButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      // height: 60,
      width: 360,
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
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => AddAddress(
                      authToken: authToken,
                    ),
                  ),
                )
                .then((value) => updateAddressBook());
          },
          child: const Text(
            'Add a New Address',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.5,
              letterSpacing: 0.0,
              color: Color(0xFF333366),
            ),
          ),
        ),
      ),
    );
  }

  Widget AddressData(Color containerColor, String status, String name,
      String address, String street, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 2, right: 10, left: 10, bottom: 40),
      height: 165.0,
      decoration: const BoxDecoration(
        color: Colors.blue,
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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 15, right: 15),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Text(
                status,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: Text(
                name,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                address,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8.0, left: 10),
              child: Text(
                street,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
