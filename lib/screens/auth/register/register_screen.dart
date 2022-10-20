import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/text_field_container.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/CityModel.dart';
import 'package:colombo_express_client/models/CountryModel.dart';
import 'package:colombo_express_client/models/StateModel.dart';
import 'package:colombo_express_client/models/ValidateUserModel.dart';
import 'package:colombo_express_client/screens/auth/login/login_screen.dart';
import 'package:colombo_express_client/screens/auth/register/register_success.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  bool _isObscure = true;

  bool _isObscureConf = true;
  bool isLoading = false;

  AppRepository appRepo = AppRepository(authToken: "");

  final _registerContactformKey = GlobalKey<FormState>();
  final _registerPersonalformKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPassController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  TabController? _tabController;

  int _selectedTab = 0;

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
        cityData = cities;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController!.index;
        });
      }
    });

    getCountries();
  }

  void _toggleTab() {
    _selectedTab = _tabController!.index + 1;
    _tabController!.animateTo(_selectedTab);
  }

  @override
  void dispose() {
    _tabController!.dispose();

    super.dispose();
  }

  // late TabController controller;

  // String? country;
  // final countryItems = ['Sri Lanka', 'New York', 'London', 'America', 'India'];
  // String? countryState;
  // List countryStateItems = [
  //   'Sri Lanka',
  //   'New York',
  //   'London',
  //   'America',
  //   'India'
  // ];
  // String? city;
  // final cityItems = ['Sri Lanka', 'New York', 'London', 'America', 'India'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double height = MediaQuery.of(context).size.height;

    setState(() {
      print(height);
    });

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.transparent,
                  // title: const Text('NestedScrollView'),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Column(
                      children: [
                        ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                            alignment: Alignment.center,
                            height: 305,
                            width: size.width,
                            decoration: const BoxDecoration(
                              color: loginHeaderColor,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Image.asset(
                                        'assets/images/Colombo-Express-Logo-2-1.png'),
                                    width: 350,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // )
                      ],
                    ),
                  ),
                  expandedHeight: 315,
                  bottom: TabBar(
                    labelColor: const Color(0xFF3a668b),
                    unselectedLabelColor: const Color(0xFFc5cfd8),
                    indicatorColor: const Color(0xFF3a668b),
                    indicatorWeight: 4,
                    indicatorSize: TabBarIndicatorSize.label,
                    enableFeedback: true,
                    padding: const EdgeInsets.all(0),
                    labelPadding: const EdgeInsets.all(0),
                    controller: _tabController,
                    onTap: (index) {
                      setState(() {
                        _tabController!.index = 0;
                      });
                    },
                    tabs: [
                      Tab(
                        height: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('STEP 1'),
                            Text('Personal Information'),
                          ],
                        ),
                      ),
                      Tab(
                        height: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('STEP 2'),
                            Text('Contact Information'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        _registerPersonalForm(),
                        _registerContactForm(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _registerPersonalForm() {
    // GlobalKey<FormState> _registerContactformKey = GlobalKey<FormState>();
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Form(
          key: _registerContactformKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _emailField(),
                  _passwordField(),
                  _confirmPasswordField(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: const Text(
                      "By signing up, you agree to Terms of Service and Privacy Policy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 60,
                    width: 360,
                    decoration: BoxDecoration(
                      color: loginbuttonColor,
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
                          if (_registerContactformKey.currentState!
                              .validate()) {
                            validateUser(context);
                          } else {}
                        },
                        child: !isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Next Step',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      letterSpacing: 0.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Divider(
                    color: Colors.grey,
                    endIndent: 10,
                    indent: 10,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: const Text(
                      "Already have an Account ?",
                      style: TextStyle(
                        fontSize: 21,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void validateUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    // try {
    //   var email = _email.text;
    //   var password = _passwordController.text;
    //   ValidateUserModel validateusermodel = await appRepo.validateUser({
    //     'email': email,
    //     'password': password,
    //   });

    try {
      _showSnackBar(context, "Validating your email address");
      var email = _email.text;
      var password = _passwordController.text;

      ValidateUserModel validateusermodel = await appRepo.validateUser({
        'email': email,
        'password': password,
      });

      setState(() {
        isLoading = false;
        _toggleTab();
      });
      _showSnackBar(context, "Email address validated");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar(context, "You already have an account");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _registerContactForm() {
    // GlobalKey<FormState> _registerContactformKey = GlobalKey<FormState>();
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Form(
          key: _registerPersonalformKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _userFirstnameField(),
                  _userLastnameField(),
                  _contactField(),
                  _userAddressField(),
                  _countrySelect(),
                  _countryStateSelect(),
                  _citySelect(),
                  _postalCodeField(),
                  const SizedBox(
                    height: 20,
                  ),
                  // _registerButton(),
                  Container(
                    height: 60,
                    width: 360,
                    decoration: BoxDecoration(
                      color: loginbuttonColor,
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
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });

                          if (_registerPersonalformKey.currentState!
                              .validate()) {
                            registerUser(context);
                          } else {}
                          // registerUser(context);
                        },
                        child: !isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Register',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      letterSpacing: 0.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: IconButton(
                                      onPressed: () {
                                        if (_registerPersonalformKey
                                            .currentState!
                                            .validate()) {
                                          registerUser(context);
                                        } else {}
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void registerUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      var email = _email.text;
      var password = _passwordController.text;
      var confirmpassword = _confPassController.text;
      var firstname = _fnameController.text;
      var lastname = _lnameController.text;
      var number = _phoneController.text;
      var address = _addressController.text;
      var country = countryValue.toString();
      var state = stateValue.toString();
      var city = cityValue.toString();
      var postalcode = _postalCodeController.text;

      _showSnackBar(context, "Creating your account");

      bool insertUsermodel = await appRepo.insertUser({
        'email': email,
        'password': password,
        'password_confirmation': confirmpassword,
        'first_name': firstname,
        'last_name': lastname,
        'phone': number,
        'address': address,
        'country_id': country,
        'state_id': state,
        'city_id': city,
        'zip_code': postalcode,
      });
      if (insertUsermodel) {
        setState(() {
          isLoading = false;
          // _toggleTab();

          // email = validateusermodel as String;
        });
        _showSnackBar(context, "Registration Successfull!");

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RegisterSuccess(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar(context, "Error processing register.");
      print(e);
    }
  }

  Widget _emailField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _email,
        decoration: InputDecoration(
            // icon: Icon(
            //   Icons.email_outlined,
            //   color: primaryColorA,
            // ),
            hintText: 'Email',
            border: InputBorder.none),
        keyboardType: TextInputType.emailAddress,
        autofillHints: [AutofillHints.email],
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
        // onChanged: (value) =>
        //     context.read<SignupBloc>().add(SignupEmailChange(email: value)),
      ),
    );
  }

  Widget _passwordField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _passwordController,
        obscureText: _isObscure,
        decoration: InputDecoration(
          // icon: Icon(
          //   Icons.security_outlined,
          //   color: loginHeaderColor,
          // ),
          hintText: 'Password',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            color: loginHeaderColor,
            onPressed: () => setState(
              () {
                _isObscure = !_isObscure;
              },
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
          if (value.length < 8) {
            return 'Password should have 8 characters';
          }
        },
        // onChanged: (value) => context
        //     .read<SignupBloc>()
        //     .add(SignupPasswordChange(password: value)),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _confPassController,
        obscureText: _isObscureConf,
        decoration: InputDecoration(
          // icon: Icon(
          //   Icons.security_outlined,
          //   color: primaryColorA,
          // ),
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
          // if (value!.isEmpty) {
          //   return 'This field is required';
          // }
          // if (value == _passwordController.text) {
          //   return 'Password does not match';
          // }
          if (value!.isEmpty) return 'This field is required';
          if (value != _passwordController.text)
            return 'Password does not match';
          return null;
        },
        // onChanged: (value) => context
        //     .read<SignupBloc>()
        //     .add(SignupConfirmPasswordChange(confirmPassword: value)),
      ),
    );
  }

  Widget _loginButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              controller: TextEditingController(),
            ),
          ),
        );
      },
      child: const Text(
        'Sign in to Account',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      color: registerbuttonColor,
      shape: const StadiumBorder(),
    );
  }

  Widget _userFirstnameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _fnameController,
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

  Widget _userLastnameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _lnameController,
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

  Widget _contactField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _phoneController,
        autofillHints: const [AutofillHints.telephoneNumber],
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          hintText: 'Contact Number',
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

  Widget _userAddressField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _addressController,
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
              countryValue = value;
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
              // print(value);
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
            cityValue = value;
          });
        },
        value: cityValue,
      ),
    ));
  }

  Widget _postalCodeField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: _postalCodeController,
        decoration: const InputDecoration(
          hintText: 'Postal Code',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
