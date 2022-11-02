// ignore_for_file: depend_on_referenced_packages

import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/color.dart';
import 'constants.dart';
import 'home.dart';
import 'login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  currentUser = prefs.getString("user");
  invoiceNo = prefs.getInt('invoice');

  WidgetsFlutterBinding.ensureInitialized();
  Firestore.initialize(projectId);

  runApp(const MyApp());
}

const apiKey = 'AIzaSyDpMoVaa_Y8LGoKn8sp-C_PXcb7z1Jdcpg';
const projectId = 'awt-inventory-system';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'AWT',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Palette.primary),
      ),
      home: currentUser == null || currentUser == ''
          ? const LoginScreen()
          : const HomeScreen(cname: '', cr: 0, id: ''),
    );
  }
}

class Palette {
  static Color primary = black;
}
