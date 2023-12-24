import 'package:flutter/material.dart';

import '../respository/navigation_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    navigateToLoginPage();
  }

  void navigateToLoginPage() async {
    await Future.delayed(const Duration(seconds: 3));
    NavigationService().routeTo('/LoginPage', arguments: 'just a test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/launch.png'),
            const Text(
              "司機專用",
              style: TextStyle(
                color: Colors.white, // Set the text color to gray
                fontSize: 30, // Set the font size to 40
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
}
