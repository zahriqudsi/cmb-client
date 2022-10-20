import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/components/text_field_container.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/CityModel.dart';
import 'package:colombo_express_client/models/CountryModel.dart';
import 'package:colombo_express_client/models/StateModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddAddress extends StatefulWidget {
  final TokenModel authToken;
  const AddAddress({Key? key, required this.authToken}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState(authToken: authToken);
}

class _AddAddressState extends State<AddAddress> {
  AppRepository appRepo = AppRepository(authToken: "");
  TokenModel authToken;

  _AddAddressState({required this.authToken});

  final myHome = TextEditingController();
  final fname = TextEditingController();
  final lname = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final postCode = TextEditingController();

  bool isLoading = false;

  late List<CountryModel> countryData = [];
  late List<StateModel> stateData = [];
  late List<CityModel> cityData = [];

  String? countryValue;
  String? stateValue;
  String? cityValue;

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);

    getCountries();
  }

  void getCountries() async {
    try {
      List<CountryModel> countries = await appRepo.getCountries();

      setState(() {
        // print(countries.length);
        countryData = countries;
      });
    } catch (e) {
      print(e);
    }
  }

  void getStates(String countryid) async {
    try {
      List<StateModel> states = await appRepo.getState(countryid);

      setState(() {
        print(states);
        stateData = states;
      });
    } catch (e) {
      print(e);
    }
  }

  void getCities(String stateid) async {
    try {
      List<CityModel> cities = await appRepo.getCities(stateid);

      setState(() {
        // print(cities);
        cityData = cities;
      });
    } catch (e) {
      print(e);
    }
  }

  void createAddress() async {
    try {
      setState(() {
        isLoading = true;
      });

      bool status = await appRepo.crateAddress({
        "label": myHome.text,
        "first_name": fname.text,
        "last_name": lname.text,
        "email": email.text,
        "phone": phone.text,
        "address": address.text,
        "country_id": countryValue,
        "state_id": stateValue,
        "city_id": cityValue,
        "zip_code": postCode.text
      });

      setState(() {
        isLoading = false;
      });

      if (status) {
        _showSnackBar("Address added!");
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("Error creating address");
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
              'Address Book',
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
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: const Text(
                        "Add New Addresses",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Address Alias",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    myHomeField(),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Address Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    firstnameField(),
                    lastnameField(),
                    contactField(),
                    emailField(),
                    addressField(),
                    countrySelect(),
                    countryStateSelect(),
                    citySelect(),
                    postalCodeField(),
                    const SizedBox(
                      height: 20,
                    ),
                    submitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myHomeField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: myHome,
        autofillHints: const [AutofillHints.name],
        decoration: const InputDecoration(
          hintText: 'E.g. My Home',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
        },
      ),
    );
  }

  Widget firstnameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: fname,
        autofillHints: const [AutofillHints.name],
        decoration: const InputDecoration(
          hintText: 'First Name',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
        },
      ),
    );
  }

  Widget lastnameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: lname,
        autofillHints: const [AutofillHints.name],
        decoration: const InputDecoration(
          hintText: 'Last Name',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
        },
      ),
    );
  }

  Widget contactField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: phone,
        autofillHints: const [AutofillHints.telephoneNumber],
        decoration: const InputDecoration(
          hintText: 'Contact Number',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
          if (value.length != 10) {
            return 'Enter a valid phone number';
          }
        },
      ),
    );
  }

  Widget emailField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: email,
        decoration:
            const InputDecoration(hintText: 'Email', border: InputBorder.none),
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
          if (!value.contains('@')) {
            return "A valid email should contain '@'";
          }
          if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(value)) {
            return "Please enter a valid email";
          }
        },
      ),
    );
  }

  Widget addressField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: address,
        autofillHints: const [AutofillHints.name],
        decoration: const InputDecoration(
          hintText: 'Address',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
        },
      ),
    );
  }

  Widget countrySelect() {
    return TextFieldContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: const Text("Select Country"),
          items: countryData
              .map((country) => DropdownMenuItem<String>(
                    child: Text(country.country),
                    value: country.id.toString(),
                  ))
              .toList(),
          onChanged: (String? value) {
            setState(() {
              getStates(value!);
              print(value);
              countryValue = value;
            });
          },
          value: countryValue,
        ),
      ),
    );
  }

  Widget countryStateSelect() {
    return TextFieldContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: const Text("Select City"),
          items: stateData
              .map((state) => DropdownMenuItem<String>(
                    child: Text(state.state),
                    value: state.id.toString(),
                  ))
              .toList(),
          onChanged: (String? value) {
            setState(() {
              print(value);
              getCities(value!);
              stateValue = value;
            });
          },
          value: stateValue,
        ),
      ),
    );
  }

  Widget citySelect() {
    return TextFieldContainer(
        child: DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        hint: const Text("Select City"),
        items: cityData
            .map((city) => DropdownMenuItem<String>(
                  child: Text(city.city),
                  value: city.id.toString(),
                ))
            .toList(),
        onChanged: (String? value) {
          setState(() {
            // print();
            cityValue = value;
          });
        },
        value: cityValue,
      ),
    ));
  }

  Widget postalCodeField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: postCode,
        // autofillHints: const [AutofillHints.telephoneNumber],
        decoration: const InputDecoration(
          hintText: 'Postal Code',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget submitButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        createAddress();
      },
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const Text(
              'ADD',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Proxima',
              ),
            ),
      color: loginbuttonColor,
      shape: const StadiumBorder(),
    );
  }
}
