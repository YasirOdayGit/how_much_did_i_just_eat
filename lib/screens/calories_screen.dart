import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:how_much_did_i_just_eat/config/colors_.dart';
import 'package:how_much_did_i_just_eat/modules/food_module.dart';
import 'package:faker/faker.dart';

import '../config/styles_.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({Key? key}) : super(key: key);

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  bool _loading = false;
  final _key = GlobalKey<FormState>(); // the form key for validaiton
  final _form = TextEditingController(); // controller for the Textfield
  FToast fToast = FToast();
  double totalCalories = 0;
  final Dio _dio = Dio(BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: 6 * 1000, // 6 seconds
    receiveTimeout: 6 * 1000, // 6 seconds
  ));
  List<FoodModule> foods = [];
  Future<void> getCalories() async {
    try {
      Response response = await _dio.get(
          "https://api.calorieninjas.com/v1/nutrition?query=" +
              _form.text.trim().toLowerCase());
      if (response.data != null && response.data['items'].length != 0) {
        foods.clear();
        totalCalories = 0;
        for (var item in response.data['items']) {
          foods.add(FoodModule.fromJSON(item));
          totalCalories += foods.last.calories ?? 0;
        }
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _showToast();
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // add your key to the request headers
    // API key should be with value X-Api-Key
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers["X-Api-Key"] = dotenv.get("api_key");
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }

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
                "Enter a food or drink items with or without quantity. Quantity can be any unit of measurement",
                style: boldStyleBig,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Form(
                    key: _key,
                    child: TextFormField(
                      controller: _form,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Cannot be empty";
                        }
                        // only accept digits words and spaces
                        if (!RegExp(r"[/d /w /s]").hasMatch(value)) {
                          return "Invalid character";
                        }
                        return null;
                      },
                      style: boldStyleBig.copyWith(color: iconColor),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none),
                          errorStyle: boldStyleSmall.copyWith(
                              color: redLevelTwo, fontSize: 12),
                          hintText: "1 Ribeye steak with 50g rice",
                          hintStyle:
                              boldStyleBig.copyWith(color: fadedIconColor)),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_loading && _key.currentState!.validate()) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _loading = true;
                        getCalories();
                      });
                    }
                  },
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "I can handle it",
                          style: boldStyleBig.copyWith(color: Colors.white),
                        ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(blueLevelTwo),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12))),
                ),
              ),
              if (foods.isNotEmpty)
                const SizedBox(
                  height: 16,
                ),
              if (foods.isNotEmpty)
                Text(
                  "You've ate a total of " +
                      totalCalories.toStringAsFixed(2) +
                      " calories",
                  style: boldStyleBig,
                  textAlign: TextAlign.center,
                ),
              if (foods.isNotEmpty)
                ...List.generate(
                    foods.length,
                    (index) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            // image: DecorationImage(
                            //   image: NetworkImage(Faker().image.image(
                            //       keywords: [
                            //         foods[index].nameOfFood!,
                            //         'food',
                            //         'drink'
                            //       ])),
                            //   fit: BoxFit.cover,
                            //   colorFilter: const ColorFilter.mode(
                            //       Colors.white70, BlendMode.lighten),
                            // ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Food name : " + foods[index].nameOfFood!,
                                style:
                                    boldStyleBig.copyWith(color: Colors.black),
                              ),
                              RowInformationDouble(
                                  title: "Calories Per ",
                                  amount: foods[index].servingSize!,
                                  measure: " g"),
                              RowInformationDouble(
                                  title: "Total Calories ",
                                  amount: foods[index].calories!,
                                  measure: " g",
                                  perecntage:
                                      foods[index].calories! / 2000 * 100),
                              RowInformationDouble(
                                  title: "Total fats ",
                                  amount: foods[index].fatT!,
                                  measure: " g",
                                  perecntage:
                                      foods[index].fatT! * 9 / 600 * 100),
                              RowInformationDouble(
                                  title: "Total carbs ",
                                  amount: foods[index].carbs!,
                                  measure: " g",
                                  perecntage:
                                      foods[index].carbs! * 4 / 800 * 100),
                              RowInformationDouble(
                                  title: "Total protein ",
                                  amount: foods[index].protein!,
                                  measure: " g",
                                  perecntage:
                                      foods[index].protein! * 4 / 600 * 100),
                              RowInformationDouble(
                                  title: "Total Sodium ",
                                  amount: foods[index].sodium!,
                                  measure: " mg",
                                  perecntage: foods[index].sodium! / 2300 * 100)
                            ],
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 3,
                spreadRadius: 1,
                offset: const Offset(3, 3))
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            color: redLevelTwo,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            "An error occured",
            style: boldStyleBig,
          ),
        ],
      ),
    );
    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: 16.0,
            right: 16.0,
          );
        });
  }
}

class RowInformationDouble extends StatelessWidget {
  const RowInformationDouble({
    Key? key,
    required this.title,
    required this.amount,
    required this.measure,
    this.perecntage,
  }) : super(key: key);
  final String title;
  final double amount;
  final String measure;
  final double? perecntage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          FittedBox(
            child: Text(title,
                style: boldStyleSmall.copyWith(color: Colors.black)),
          ),
          Expanded(
              child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(amount.toStringAsFixed(2) + measure,
                style: boldStyleSmall.copyWith(
                    fontWeight: FontWeight.normal, color: Colors.black)),
          )),
          if (perecntage != null)
            Text(
              perecntage!.toStringAsFixed(0) + "%",
              style: boldStyleSmall.copyWith(color: Colors.black),
            )
        ],
      ),
    );
  }
}
