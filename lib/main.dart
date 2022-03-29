import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:how_much_did_i_just_eat/config/colors_.dart';
import 'package:how_much_did_i_just_eat/screens/calories_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // enviromental variable that includes your API key
  await dotenv.load(fileName: ".env");
  // disables rotation and sets the SafeArea color
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: iconColor));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // safe area because we're not using any appbars
      home: SafeArea(child: CaloriesScreen()),
    );
  }
}
