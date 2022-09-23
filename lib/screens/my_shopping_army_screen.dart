import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/Helper.dart';
import '../utils/color_constant.dart';
import '../widgets/qr_image_with_title.dart';

class MyShoppingArmy extends StatefulWidget {
  final String qrData;

  const MyShoppingArmy({Key? key, required this.qrData}) : super(key: key);

  @override
  State<MyShoppingArmy> createState() => _MyShoppingArmyState();
}

class _MyShoppingArmyState extends State<MyShoppingArmy> {
  String _amazonlink = '';

  String _walmartlink = '';

  String _targetlink = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences getSharedPreferenceObject = sharedPreferences;

    if (getSharedPreferenceObject.getString('amazonlink') != null &&
        jsonDecode(getSharedPreferenceObject.getString('amazonlink')!) != '') {
      Map<String, dynamic> userMap =
          jsonDecode(getSharedPreferenceObject.getString('amazonlink')!)
              as Map<String, dynamic>;
      _amazonlink = json.encode(userMap);
    }
    if (getSharedPreferenceObject.getString('walmartLink') != null &&
        jsonDecode(getSharedPreferenceObject.getString('walmartLink')!) != '') {
      Map<String, dynamic> userMap =
          jsonDecode(getSharedPreferenceObject.getString('walmartLink')!)
              as Map<String, dynamic>;

      _walmartlink = json.encode(userMap);
    }
    if (getSharedPreferenceObject.getString('targetLink') != null &&
        jsonDecode(getSharedPreferenceObject.getString('targetLink')!) != '') {
      Map<String, dynamic> userMap =
          jsonDecode(getSharedPreferenceObject.getString('targetLink')!)
              as Map<String, dynamic>;

      _targetlink = json.encode(userMap);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "My Shopping Army",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.kprimeryColor,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, bottom: 20, top: 10),
                child: GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(Uri.parse(
                        'https://www.mediafire.com/file/05as91srnyiik3e/QRCodeExplanation.mp4/file'))) {
                      throw 'Could not launch https://www.mediafire.com/file/05as91srnyiik3e/QRCodeExplanation.mp4/file';
                    }
                  },
                  child: Text(
                    'QR Code Training Video',
                    style: TextStyle(
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 80.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/Images/click.png'),
                    ),
                    InkWell(
                      onTap: () {
                        showCustomDialog(context, 'http://billsecret-app.mg-mg.xyz');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, bottom: 20, top: 10, right: 10),
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: Image.asset('assets/Images/qr.jpeg'),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Text('Get BillSecret App'),
              _amazonlink != null && _amazonlink != ''
                  ? QrImageWithTitle(_amazonlink, 'My Amazon', () {
                      setState(() {
                        _amazonlink = '';
                        sharedPreferences.setString(
                            "amazonlink", jsonEncode(''));
                      });
                    }, () {
                      showCustomDialog(context, _amazonlink);
                    })
                  : const Offstage(),
              _walmartlink != null && _walmartlink != ''
                  ? QrImageWithTitle(_walmartlink, 'My Walmart', () {
                      setState(() {
                        _walmartlink = '';
                        sharedPreferences.setString(
                            "walmartLink", jsonEncode(''));
                      });
                    }, () {
                      showCustomDialog(context, _walmartlink);
                    })
                  : const Offstage(),
              _targetlink != null && _targetlink != ''
                  ? QrImageWithTitle(_targetlink, 'My Target', () {
                      setState(() {
                        _targetlink = '';
                        sharedPreferences.setString(
                            "targetLink", jsonEncode(''));
                      });
                    }, () {
                      showCustomDialog(context, _targetlink);
                    })
                  : const Offstage(),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context, String QrCode) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            alignment: Alignment.center,
            height: 350,
            width: 500,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: SizedBox(
              child: QrImage(
                data: QrCode,
                version: QrVersions.auto,
                size: 400,
                gapless: false,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
