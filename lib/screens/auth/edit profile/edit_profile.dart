import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/main_drawer.dart';
import 'package:colombo_express_client/components/text_field_container.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/CityModel.dart';
import 'package:colombo_express_client/models/CountryModel.dart';
import 'package:colombo_express_client/models/StateModel.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/models/UserModel.dart';
import 'package:colombo_express_client/screens/auth/edit%20profile/save_information.dart';
import 'package:colombo_express_client/screens/pickups/pickups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfile extends StatefulWidget {
  final TokenModel authToken;
  final TextEditingController controller;

  const EditProfile(
      {Key? key, required this.controller, required this.authToken})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(authToken: authToken);
}

class _EditProfileState extends State<EditProfile> {
  final TokenModel authToken;
  final fNamecontroller = TextEditingController();
  final lNamecontroller = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final zipcodeController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscureConf = true;
  bool isLoading = false;
  late UserModel profile;
  final _formKey = GlobalKey<FormState>();

  _EditProfileState({required this.authToken});

  AppRepository appRepo = AppRepository(authToken: "");

  late List<CountryModel> countryData = [];
  late List<StateModel> stateData = [];
  late List<CityModel> cityData = [];

  String? countryValue;
  String? stateValue;
  String? cityValue;

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

  getStates(String countryid) async {
    try {
      List<StateModel> states = await appRepo.getState(countryid);

      setState(() {
        // print(states);
        stateData = states;
      });
    } catch (e) {
      print(e);
    }
  }

  getCities(String stateid) async {
    try {
      List<CityModel> cities = await appRepo.getCities(stateid);

      setState(() {
        print(cities);
        cityData = cities;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    appRepo = AppRepository(authToken: authToken.token);
    widget.controller.addListener(onListen);

    getUser();
    print("user details fetched");
  }

  void getUser() async {
    try {
      UserModel user = await appRepo.getUser();

      setState(() {
        profile = user;

        //       print('Country name controller set');
        // stateValue = user.addressModel!.state.toString();
        // cityValue = user.addressModel!.city.toString();
      });
      fNamecontroller.text = user.firstName!;
      lNamecontroller.text = user.lastName!;
      emailController.text = user.email!;
      phoneController.text = user.addressModel!.phone!;
      zipcodeController.text = user.addressModel!.zipCode!;
      addressController.text = user.addressModel!.address!;
      stateValue = user.addressModel!.state.toString();
      cityValue = user.addressModel!.city.toString();
      getCountries();
      setState(() {
        countryValue = user.addressModel!.country!.id.toString();
      });

      getStates(countryValue.toString());
      setState(() {
        stateValue = user.addressModel!.state!.id.toString();
      });

      getCities(stateValue.toString());
      setState(() {
        cityValue = user.addressModel!.city!.id.toString();
      });
    } catch (e) {
      print(e);
      _showSnackBar(context, "Error loading profile");
    }
  }

  void updateProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserModel users = await appRepo.updateProfile({
        'first_name': fNamecontroller.text,
        'last_name': lNamecontroller.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'zip_code': zipcodeController.text,
        'country_id': countryValue.toString(),
        'state_id': stateValue.toString(),
        'city_id': cityValue.toString(),
      });

      setState(() {
        isLoading = false;
        print(users);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SaveInformation(
              authToken: authToken,
            ),
          ),
        );
      });
      _showSnackBar(context, "Profile updated");
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      _showSnackBar(context, "Could not update profile");
    }
  }

  void passwordUpdate() async {
    setState(() {
      isLoading = true;
    });

    try {
      var password = passwordController.text;
      var confPass = conpasswordController.text;

      bool passUpdate = await appRepo.updatePassword({
        'password': password,
        'password_confirmation': confPass,
      });

      setState(() {
        print(passUpdate);
        isLoading = false;
      });
      _showSnackBar(context, "Password Updated Succesfully");
    } catch (e) {
      print(e);

      _showSnackBar(context, "Could not update password.");
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);

    super.dispose();
  }

  void onListen() => setState(() {});

  String? country;
  final countryItems = ['Sri Lanka', 'New York', 'London', 'America', 'India'];
  String? countryState;
  List countryStateItems = [
    'Sri Lanka',
    'New York',
    'London',
    'America',
    'India'
  ];
  String? city;
  final cityItems = ['Sri Lanka', 'New York', 'London', 'America', 'India'];

  // bool isLoading = false;

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
              'Edit Profile',
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
      backgroundColor: loginHeaderColor,
      body: SafeArea(
        child: ListView(
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
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 25, right: 25, bottom: 20),
                child: profileUpdateForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void updateProfile(BuildContext context) async {
  //   setState(() {
  //     // is
  //   });

  //   try {
  //     var fname = fNamecontroller.text;
  //     var lname = lNamecontroller.text;

  //     UserModel users = await appRepo.updateProfile({
  //       'first_name': fname,
  //       'last_name': lname,
  //     });

  //     print(users);
  //   } catch (e) {}
  // }

  Widget profileUpdateForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          _firstnameField(),
          _lastnameField(),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              top: 50,
            ),
            child: const Text(
              "Contact Information",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          _emailField(),
          _phonenumberField(),
          _addressField(),
          _countrySelect(),
          _countryStateSelect(),
          _citySelect(),
          _postcodeField(),
          const SizedBox(
            height: 20,
          ),
          _saveInfoButton(),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              top: 50,
            ),
            child: const Text(
              "Change Password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _passwordfield(),
          _conformpasswordfield(),
          const SizedBox(
            height: 20,
          ),
          _updatePasswordButton(),
        ],
      ),
    );
  }

  Widget _firstnameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: fNamecontroller,
        decoration: const InputDecoration(
          hintText: 'First Name',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _lastnameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: lNamecontroller,
        decoration: const InputDecoration(
          hintText: 'Last Name',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          hintText: 'Email',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _phonenumberField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: phoneController,
        decoration: const InputDecoration(
          hintText: 'Phone Number',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _addressField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: addressController,
        decoration: const InputDecoration(
          hintText: 'Address',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _countrySelect() {
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
              stateValue = null;
              cityValue = null;
            });
          },
          value: countryValue,
        ),
      ),
    );
  }

  Widget _countryStateSelect() {
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

  Widget _citySelect() {
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

  Widget _postcodeField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: zipcodeController,
        decoration: const InputDecoration(
          hintText: 'PostCode',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _saveInfoButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        updateProfile();
        print('sending user');
      },
      child: const Text(
        'Save information',
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

  Widget _passwordfield() {
    return TextFieldContainer(
      child: TextFormField(
        controller: passwordController,
        decoration: const InputDecoration(
          hintText: 'Password',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _conformpasswordfield() {
    return TextFieldContainer(
      child: TextFormField(
        controller: conpasswordController,
        obscureText: _isObscureConf,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon:
                Icon(_isObscureConf ? Icons.visibility : Icons.visibility_off),
            color: loginHeaderColor,
            onPressed: () => setState(
              () {
                _isObscureConf = !_isObscureConf;
              },
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
          if (value == passwordController) {
            return 'Password does not match';
          }
        },
        // onChanged: (value) => context
        //     .read<SignupBloc>()
        //     .add(SignupConfirmPasswordChange(confirmPassword: value)),
      ),
    );
  }

  Widget _updatePasswordButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        passwordUpdate();
        print('password updated');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SaveInformation(
              authToken: authToken,
            ),
          ),
        );
      },
      child: const Text(
        'Update Password',
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

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
