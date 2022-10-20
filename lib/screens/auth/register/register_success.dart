import 'package:colombo_express_client/api/app_repository.dart';
import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterSuccess extends StatefulWidget {
  const RegisterSuccess({Key? key}) : super(key: key);

  @override
  State<RegisterSuccess> createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  TextEditingController emailController = TextEditingController();

  AppRepository appRepo = AppRepository(authToken: "");

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                        "Register",
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
              // const SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
                child: Column(
                  children: [
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/checkmark.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      // padding: const EdgeInsets.only(left: 40, right: 40),
                      child: const Text(
                        "Your account for CMB Express has been created",
                        style: TextStyle(
                          fontSize: 20,
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
                    Container(
                      child: const Text(
                        "Before proceeding, please check your email for a verification link.",
                        style: TextStyle(
                          fontSize: 18,
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
                    _resendVerificationButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    _backToLoginButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sendVerificationEmail(BuildContext context) async {
    if (emailController.text.isEmpty) {
      return false;
    }

    try {
      bool sendverification =
          await appRepo.sendVerifyEmail(emailController.text);

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => LoginScreen(
      //       controller: TextEditingController(),
      //     ),
      //   ),
      // );
      if (sendverification) {
        setState(() {
          isLoading = false;
          // _toggleTab();

          // email = validateusermodel as String;
        });
        _showSnackBar(
            context, "User verification email has been sent to your email!");

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const RegisterSuccess(),
        //   ),
        // );
      }
    } catch (e) {
      _showSnackBar(context, "Error processing request");
    }
    // if (emailController.text.isEmpty) {
    //   return false;
    // }

    // try {
    //   bool sendVerification =
    //       await appRepo.sendVerifyEmail(emailController.text);
    //   print(sendVerification);
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (context) => LoginScreen(controller: TextEditingController()),
    //   ));
    //   _showSnackBar(context, 'Email Verification sent.');
    // } catch (e) {
    //   print(e);
    // }
  }

  Widget _resendVerificationButton() {
    return FlatButton(
      minWidth: 360,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      onPressed: () {
        sendVerificationEmail(context);
        _showSnackBar(
            context, "User verification email has been sent to your email!");
      },
      child: const Text(
        'Resend Verification Email',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      color: loginbuttonColor,
      shape: const StadiumBorder(),
    );
  }

  Widget _backToLoginButton() {
    return Container(
      height: 60,
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginScreen(
                  controller: TextEditingController(),
                ),
              ),
            );
            _showSnackBar(context, 'Login to Continue.');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.arrow_back)),
              const Text(
                'Back to Login',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.0,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
