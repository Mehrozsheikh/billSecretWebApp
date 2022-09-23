import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'home.dart';
import 'terms_condition_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    viewFunction();
    super.initState();
  }

  void viewFunction() async {
    DateTime currentDate = DateTime.now();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? agreement = preferences.getBool("agreement");
    if (agreement != null) {
      agreement = true;
    } else {
      String format =
          DateFormat.yMMMMEEEEd().format(currentDate.add(Duration(days: 30)));
      preferences
          .setString("NextDate", format)
          .then((value) => print("Save date"));

      print(format);

      agreement = false;
    }

    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                agreement == true ? MyHomePage() : const TermConditionScreen()),
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/Images/AppIcon.jpeg"))
                  // color: Colors.accents,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
