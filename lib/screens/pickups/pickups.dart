import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/components/text_field_container.dart';
import 'package:colombo_express_client/components/text_field_detail.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/AddresssBookItemModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/dashboard/dashboard_screen.dart';
import 'package:colombo_express_client/screens/myAddress/addAddress.dart';
import 'package:colombo_express_client/screens/myAddress/changeAddress.dart';
import 'package:colombo_express_client/screens/myAddress/myaddress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Pickups extends StatefulWidget {
  final TokenModel authToken;
  const Pickups({Key? key, required this.authToken}) : super(key: key);

  @override
  _PickupsState createState() => _PickupsState(authToken: authToken);
}

class _PickupsState extends State<Pickups> {
  final TokenModel authToken;
  _PickupsState({required this.authToken});
  AppRepository appRepo = AppRepository(authToken: "");

  TextEditingController date = TextEditingController();
  TextEditingController width = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController length = TextEditingController();
  ScrollController _scrollCont = ScrollController(keepScrollOffset: true);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  AddresssBookItemModel? pickupAddress;
  AddresssBookItemModel? receiversAddress;
  late DateTime selectedDate;
  late DateTime lastDate;
  late DateFormat dateFormat;
  late DateFormat dateAPIFormat;

  bool isDutyChecked = false;
  bool isDeliveryChecked = false;
  bool isTermsChecked = false;

  bool isLoading = false;

  @override
  void dispose() {
    _scrollCont.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);

    var now = new DateTime.now();
    var t = now.add(new Duration(days: 1));

    selectedDate = t;

    lastDate = now.add(new Duration(days: 365));

    dateFormat = DateFormat("dd MMM yyyy");
    dateAPIFormat = DateFormat("dd-MM-yyyy");

    date.text = dateFormat.format(selectedDate);
  }

  schedulePickup() async {
    if (selectedDate == null) {
      _showSnackBar(context, "Please select a pickup date");
      return false;
    }

    if (width.text.isEmpty) {
      _showSnackBar(context, "Package width can not be empty");
      return false;
    }

    if (height.text.isEmpty) {
      _showSnackBar(context, "Package height can not be empty");
      return false;
    }

    if (length.text.isEmpty) {
      _showSnackBar(context, "Package length can not be empty");
      return false;
    }

    if (pickupAddress == null) {
      _showSnackBar(context, "Please select pickup address");
      return false;
    }

    if (receiversAddress == null) {
      _showSnackBar(context, "Please select receiver address");
      return false;
    }

    if (!isTermsChecked) {
      _showSnackBar(context, "You need to agree with the terms to proceed");
      return false;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var _date = date.text;
      var _width = width.text;
      var _height = height.text;
      var _length = length.text;
      // var _to =

      print({
        'pickup_date': dateAPIFormat.format(selectedDate),
        'length': _length,
        'width': _width,
        'height': _height,
        'from': pickupAddress!.id.toString(),
        'to': receiversAddress!.id.toString(),
        'duty': isDutyChecked ? '1' : '0',
        'delivery': isDeliveryChecked ? '1' : '0',
        'terms': isTermsChecked ? '1' : '0'
      });

      bool sPickup = await appRepo.schedulePickup({
        'pickup_date': dateAPIFormat.format(selectedDate),
        'length': _length,
        'width': _width,
        'height': _height,
        'from': pickupAddress!.id.toString(),
        'to': receiversAddress!.id.toString(),
        'duty': isDutyChecked ? '1' : '0',
        'delivery': isDeliveryChecked ? '1' : '0',
        'terms': isTermsChecked ? '1' : '0'
      });

      setState(() {
        isLoading = false;
      });

      _showSnackBar(context, "Pickup Sheduled");
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => DashboardScreen(authToken: authToken)))
          .then((value) => schedulePickup());
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar(context, "Request could not be processed");
      print(e);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  DateTime _date = DateTime.now();

  Future<Null> selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: lastDate,
    );

    if (_datePicker != null) {
      setState(() {
        selectedDate = _datePicker;
      });

      date.text = dateFormat.format(_datePicker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: loginHeaderColor,
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
              'Schedule a Pickup',
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
        child: SingleChildScrollView(
          child: Column(
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
                    _pickupDateContainer(),
                    _pickupDetailContainer(),
                    _checkBoxesContainer(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: _pickupButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pickupDateContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 25),
      height: 300.0,
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
            padding: const EdgeInsets.only(top: 25, left: 15),
            child: const Text(
              "Pickup date*",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            child: TextFieldContainer(
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  selectDate(context);
                },
                style: const TextStyle(fontSize: 20.0, color: Colors.black),
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                  ),
                  hintText: "Tap to select a date",
                  border: InputBorder.none,
                ),
                controller: date,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, left: 15),
            child: const Text(
              "Package Details*",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 15,
                        ),
                        child: const Text(
                          "Width",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          // top: 5,
                          left: 15,
                        ),
                        child: TextFieldDetail(
                          child: TextFormField(
                            controller: width,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "0.0ft",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // child: TextField(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 15,
                        ),
                        child: const Text(
                          "Height",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          // top: 5,
                          left: 15,
                        ),
                        child: TextFieldDetail(
                          child: TextFormField(
                            controller: height,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "0.0ft",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 15,
                        ),
                        child: const Text(
                          "Length",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          // top: 5,
                          left: 15,
                        ),
                        child: TextFieldDetail(
                          child: TextFormField(
                            controller: length,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "0.0ft",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickupDetailContainer() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, bottom: 20),
          child: const Text(
            "Pickup Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 2, left: 15, right: 15, bottom: 20),
          height: 250.0,
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
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: const Text(
                        "Sender",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFcccccc),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyaddressScreen(
                              authToken: authToken,
                              callback: (AddresssBookItemModel addres) {
                                if (addres.countryId == 1) {
                                  setState(() {
                                    pickupAddress = addres;
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  _showSnackBar(context,
                                      "You Cannot Ship from Sri Lanka");
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: Chip(
                        label: const Text(
                          "CHANGE",
                          style: TextStyle(
                            color: Color(0xFFcccccc),
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 6.0,
                        shadowColor: Colors.grey[60],
                        padding: const EdgeInsets.all(6.0),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    pickupAddress != null
                        ? pickupAddress!.firstName +
                            " " +
                            pickupAddress!.lastName +
                            " " +
                            "\n " +
                            pickupAddress!.address +
                            "\n " +
                            pickupAddress!.cityName +
                            "\n " +
                            pickupAddress!.stateName +
                            " " +
                            pickupAddress!.zipCode +
                            "\n " +
                            pickupAddress!.countryName +
                            " "
                        : "",
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyaddressScreen(
                                  authToken: authToken,
                                  callback: (AddresssBookItemModel addres) {
                                    if (addres.countryId == 1) {
                                      setState(() {
                                        pickupAddress = addres;
                                        Navigator.of(context).pop();
                                      });
                                    } else {
                                      _showSnackBar(context,
                                          "You Cannot Ship from Sri Lanka");
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Add New Address',
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
                    )),
              ],
            ),
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 2, left: 15, right: 15, bottom: 20),
          height: 250.0,
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
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: const Text(
                        "Receiver",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFcccccc),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyaddressScreen(
                              authToken: authToken,
                              callback: (AddresssBookItemModel addres) {
                                if (addres.countryId == 2) {
                                  setState(() {
                                    receiversAddress = addres;
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  _showSnackBar(
                                      context, "You Cannot Recive from USA");
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: Chip(
                        label: const Text(
                          "CHANGE",
                          style: TextStyle(
                            color: Color(0xFFcccccc),
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 6.0,
                        shadowColor: Colors.grey[60],
                        padding: const EdgeInsets.all(6.0),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    // "Tauseef Ahamed \n725York Street, Burmingham, \nAlabama, 111100, \nUnited States of America",
                    receiversAddress != null
                        ? receiversAddress!.firstName +
                            " " +
                            receiversAddress!.lastName +
                            " " +
                            "\n" +
                            receiversAddress!.address +
                            "\n" +
                            receiversAddress!.cityName +
                            "\n" +
                            receiversAddress!.stateName +
                            " " +
                            receiversAddress!.zipCode +
                            "\n" +
                            receiversAddress!.countryName +
                            ""
                        : " ",
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyaddressScreen(
                                  authToken: authToken,
                                  callback: (AddresssBookItemModel addres) {
                                    if (addres.countryId == 2) {
                                      setState(() {
                                        receiversAddress = addres;
                                        Navigator.of(context).pop();
                                      });
                                    } else {
                                      _showSnackBar(context,
                                          "You Cannot Recive from USA");
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Add New Address',
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
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _addAddressButton() {
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddAddress(
                  authToken: authToken,
                ),
              ),
            );
          },
          child: const Text(
            'Add New Address',
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

  Widget _checkBoxesContainer() {
    Color getColor(Set<MaterialState> states) {
      Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          // Container(
          //   alignment: Alignment.centerLeft,
          //   child: Row(
          //     children: [
          //       Checkbox(
          //         checkColor: Colors.white,
          //         fillColor: MaterialStateProperty.resolveWith(getColor),
          //         value: isDutyChecked,
          //         onChanged: (bool? value) {
          //           setState(() {
          //             isDutyChecked = value!;
          //           });
          //         },
          //       ),
          //       Container(
          //         child: const Text(
          //           "Receiver will pay the custom duty",
          //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isDeliveryChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isDeliveryChecked = value!;
                    });
                  },
                ),
                Container(
                  child: const Text(
                    "Deliver the package to receiver's address",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isTermsChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isTermsChecked = value!;
                    });
                  },
                ),
                Container(
                  child: const Text(
                    "I accept the terms & conditions*",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickupButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        schedulePickup();
      },
      child: !isLoading
          ? const Text(
              'Schedule a Pickup',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            )
          : const CircularProgressIndicator(),
      color: loginbuttonColor,
      shape: const StadiumBorder(),
    );
  }
}
