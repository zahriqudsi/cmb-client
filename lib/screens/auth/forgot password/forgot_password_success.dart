import 'package:colombo_express_client/constant.dart';
import 'package:colombo_express_client/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordSuccess extends StatefulWidget {
  const ForgotPasswordSuccess({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordSuccess> createState() => _ForgotPasswordSuccessState();
}

class _ForgotPasswordSuccessState extends State<ForgotPasswordSuccess> {
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
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 150.0,
                      width: 150.0,
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
                      // padding: const EdgeInsets.only(left: 80, right: 80),
                      child: const Text(
                        "Forgot Password Email send to your Email",
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
                    _backToLoginButton(),
                    const SizedBox(
                      height: 50,
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

  Widget _backToLoginButton() {
    return Container(
      height: 60,
      width: 200,
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
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
