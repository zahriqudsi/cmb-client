import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/text_field_container.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/screens/auth/forgot%20password/forgot_password_success.dart';
import 'package:colombo_express_client/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  List users = [];
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  late final BuildContext pageContext;

  AppRepository appRepo = AppRepository(authToken: "");

  sendNewPassword() async {
    if (emailController.text.isEmpty) {
      _showSnackBar(context, 'Email Field Cannot be empty');

      return false;
    }

    try {
      var resetEmail = emailController.text;
      bool sendStatus = await appRepo.forgotPassword({
        'email': resetEmail,
      });

      if (sendStatus) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ForgotPasswordSuccess(),
        ));
        _showSnackBar(context, 'Password Request Email sent successfully');
      } else {
        _showSnackBar(context, 'Enter Valid Email Address');
      }
    } catch (e) {
      print(e);
      _showSnackBar(context, "Error processing request");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: loginHeaderColor,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFf3f3f3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  alignment: Alignment.center,
                  height: 350,
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: loginHeaderColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 30,
                        // ),
                        Container(
                          child: Image.asset(
                              'assets/images/Colombo-Express-Logo-2-1.png'),
                          width: 350,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _forgotPasswordForm(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(
                "Enter your email to recover your password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5c6f7e),
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            _usernameField(),
            const SizedBox(
              height: 10,
            ),
            _recoverPasswordButton(),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  // Future getCountry(country) async {
  //   Uri countryUrl = Uri.http('https://cmbex.mydemoview.com/api/customer/forgot-password');

  //   try {
  //     http.Response response = await http.get(countryUrl);
  //     Object decoded = jsonDecode(response.body)[0]['name'];
  //     print(decoded);
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Widget _usernameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          hoverColor: loginHeaderColor,
          fillColor: loginTextColor,
          focusColor: loginHeaderColor,
          hintText: 'Your Email',
          border: InputBorder.none,
        ),
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
        // onSaved: (value) => _email = value,
        // onChanged: (value) => context.read<LoginBloc>().add(
        //       LoginUsernameChange(username: value),
        //     ),
      ),
    );
  }

  Widget _recoverPasswordButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        sendNewPassword();
      },
      child: const Text(
        'Recover Password',
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
