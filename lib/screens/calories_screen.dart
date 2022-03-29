import 'package:flutter/material.dart';
import 'package:how_much_did_i_just_eat/config/colors_.dart';

import '../config/styles_.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({Key? key}) : super(key: key);

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Enter a meal name or foods followed by a space",
                style: boldStyleBig,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Form(
                    child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none),
                      hintText: "Ribeye steak with rice",
                      hintStyle: boldStyleBig.copyWith(color: fadedIconColor)),
                )),
              ),
              SizedBox(
                width: size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () {},
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Go!",
                          style: boldStyleBig.copyWith(color: Colors.white),
                        ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(blueLevelTwo),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
