import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatbill/screens/splash_screen.dart';
import 'package:whatbill/utils/Helper.dart';

void main() async {
  sharedPreferences = await SharedPreferences.getInstance();
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();

  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'BillSecret',
      home: SplashScreen(),
    );
  }
}
