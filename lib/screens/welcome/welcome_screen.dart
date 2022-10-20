import 'package:colombo_express_client/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetologin();
  }

  _navigatetologin() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                  controller: TextEditingController(),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('assets/images/Colombo-Express-Logo-2.png'),
              width: 350,
            ),
            const SizedBox(
              height: 50,
            ),
            const CircularProgressIndicator(
              color: Color(0xFF5e8fb5),
              strokeWidth: 5,
            ),
          ],
        ),
      ),
    );
  }
}
