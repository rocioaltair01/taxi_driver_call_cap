import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/splash_page.dart';
import '../pages/tabbar_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const SplashPage());
      case '/LoginPage':
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/TabbarPage':
        return MaterialPageRoute(builder: (context) => const TabbarPage());
      default:
        return MaterialPageRoute(builder: (context) => Scaffold(
          body: Center(
            child: Text("Not found ${settings.name}"),
          ),
        ));
    }
  }
}