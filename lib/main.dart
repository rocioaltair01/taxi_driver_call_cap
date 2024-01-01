
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


import 'pages/login_page.dart';
import 'pages/splash_page.dart';
import 'pages/tabbar_page.dart';
import 'pages/主畫面/main_page.dart';
import 'respository/navigation_service.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // // cameras = await availableCameras();
  // // print("ca $cameras");
  // // setupLocator();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  initializeDateFormatting('zh', null).then((_) {
    runApp(
        ChangeNotifierProvider(
            create: (context) => StatusProvider(),
            child: MyApp()
        )
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final NavigationService navigationService = NavigationService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoutes,
      initialRoute: '/',
      navigatorKey: navigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black), // Change the back button color to black
        ),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)), // Adjust the value as needed
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black,), //button color
            foregroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff),), //text (and icon)
          ),
        ),
      ),
      home: SplashPage(),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashPage());
      case '/LoginPage':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/TabbarPage':
        return MaterialPageRoute(builder: (context) => TabbarPage());
      default:
        return MaterialPageRoute(builder: (context) => Scaffold(
          body: Center(
            child: Text("Not found ${settings.name}"),
          ),
        ));
    }
  }
}