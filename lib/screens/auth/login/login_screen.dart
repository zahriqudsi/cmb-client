import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/components/text_field_container.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/models/TokenModel.dart';
import 'package:colombo_express_client/screens/auth/forgot%20password/forgot_password_screen.dart';
import 'package:colombo_express_client/screens/auth/register/register_screen.dart';
import 'package:colombo_express_client/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final TextEditingController controller;
  const LoginScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  bool _isObscure = true;

  AppRepository appRepo = AppRepository(authToken: "");

  void initState() {
    super.initState();

    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);

    super.dispose();
  }

  void onListen() => setState(() {});

  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  String message = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf3f3f3),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: _loginForm(),
            ),
          ],
        ));
  }

  Widget _loginForm() {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
                        // const SizedBox(
                        //   height: 10,
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
                          "Sign in / Register",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: const Text(
                        "Login to Account",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5c6f7e),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    _usernameField(),
                    _passwordField(),
                    const SizedBox(
                      height: 10,
                    ),
                    _loginButton(),
                    const SizedBox(
                      height: 22,
                    ),
                    // Text(message),
                    _forgotPassword(context),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(
                      color: Colors.grey,
                      // endIndent: 50,
                      // indent: 50,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: const Text(
                        "Don't have an Account?",
                        style: TextStyle(
                          fontSize: 21,
                          color: Color(0xFF495d6f),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _registerButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      var email = emailController.text;
      var password = passwordController.text;

      TokenModel userToken = await appRepo.login({
        'email': email,
        'password': password,
      });

      setState(() {
        isLoading = false;
      });
      _showSnackBar(context, "Login successful");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            authToken: userToken,
          ),
        ),
      );
      // print(email);
    } catch (e) {
      _showSnackBar(context, "These credentials do not match our records.");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _usernameField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          hoverColor: loginHeaderColor,
          fillColor: loginTextColor,
          focusColor: loginHeaderColor,
          hintText: 'Your Email',
          border: InputBorder.none,
          suffixIcon: widget.controller.text.isEmpty
              ? Container(
                  width: 0,
                )
              : IconButton(
                  icon: const Icon(Icons.close),
                  color: loginHeaderColor,
                  onPressed: () => widget.controller.clear(),
                ),
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

  Widget _passwordField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: passwordController,
        obscureText: _isObscure,
        decoration: const InputDecoration(
          hintText: 'Password',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
          if (value.length < 8) {
            return 'Password should have 8 characters';
          }
        },
        // onSaved: (newValue) => _password = newValue,
        // onChanged: (value) => context.read<LoginBloc>().add(
        //       LoginPasswordChange(password: value),
        //     ),
      ),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ForgotPasswordScreen(),
          ),
        );
      },
      child: Container(
        child: const Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: forgotpasswodTextColor,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Builder(builder: (context) {
      return FlatButton(
        minWidth: 360,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            login(context);
          }
        },
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Proxima',
                ),
              ),
        color: loginbuttonColor,
        shape: const StadiumBorder(),
      );
    });
  }

  Widget _registerButton(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ),
        );
      },
      child: const Text(
        'SIGNUP',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      color: registerbuttonColor,
      shape: const StadiumBorder(),
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
