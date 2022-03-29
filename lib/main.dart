import 'package:flutter/material.dart';
import 'package:how_much_did_i_just_eat/screens/calories_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // enviro variable that includes your API key
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(child: CaloriesScreen()),
    );
  }
}
