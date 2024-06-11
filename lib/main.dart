import 'package:alpha_forecast_app/screens/desktop_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  print("Initializing Firebase");

  WidgetsFlutterBinding.ensureInitialized();
  print("Initializing ...............");

  await Firebase.initializeApp(
      //name: 'Evyan Inspires',
      //name: 'AlphaCentauric-ABI',
      options: const FirebaseOptions(
          apiKey: "AIzaSyD6orv5y1fThpaK65k6sdSN_eIoS0-d1QU",
          authDomain: "alpha-forecast-web-app.firebaseapp.com",
          projectId: "alpha-forecast-web-app",
          storageBucket: "alpha-forecast-web-app.appspot.com",
          messagingSenderId: "69461125370",
          appId: "69461125370",
          measurementId: "G-HQ6X9DJCVP"));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print("okkk ...............");

    return MaterialApp(
      title: 'Alphacentauric Business Intelligence',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => DesktopHomeScreen()
        // '/service_screen': (context) => ServiceScreen(),
        // '/about_screen': (context) => AboutScreen(),
        // '/contact_screen': (context) => ContactScreen(),

        //  '/workshops': (context) => WorkshopsPage(),
        // Define routes for other pages
      },
    );
  }
}
