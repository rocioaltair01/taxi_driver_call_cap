import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/route_generator.dart';
import 'firebase_options.dart';
import 'pages/splash_page.dart';
import 'pages/主畫面/main_page.dart';
import 'respository/navigation_service.dart';

List<CameraDescription> cameras = <CameraDescription>[];

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  cameras = await availableCameras();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      ChangeNotifierProvider(
          create: (context) => StatusProvider(),
          child: const MyApp()
      )
  );
  // initializeDateFormatting('zh', null).then((_) {
  //   runApp(
  //       ChangeNotifierProvider(
  //           create: (context) => StatusProvider(),
  //           child: MyApp()
  //       )
  //   );
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final NavigationService navigationService = NavigationService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'TW'),
      ],
      onGenerateRoute: RouteGenerator.generateRoutes,
      initialRoute: '/',
      navigatorKey: navigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
        ),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black,),
            foregroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff),),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}