import 'package:flutter/material.dart';
import 'package:listy/data.dart';
import 'package:listy/pages/home_page.dart';
import 'package:listy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: cPrimary,
        accentColor: cWhite,
        scaffoldBackgroundColor: cBackground,
        fontFamily: "Nunito",
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: cBlack,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          bodyText1: TextStyle(
            color: cBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyText2: TextStyle(
            color: cBlack,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
