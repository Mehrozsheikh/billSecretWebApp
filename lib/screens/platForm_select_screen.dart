import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatbill/widgets/customButton.dart';

import '../utils/color_constant.dart';

class PlatformSelectionScreen extends StatefulWidget {
  bool isCheckScreen;
  PlatformSelectionScreen({Key? key, required this.isCheckScreen})
      : super(key: key);

  @override
  State<PlatformSelectionScreen> createState() =>
      _PlatformSelectionScreenState();
}

class _PlatformSelectionScreenState extends State<PlatformSelectionScreen> {
  Uri? _url;
  late SharedPreferences preferences;
  String? name;
  String? email;
  bool isAmazon = true;
  bool iswelmart = false;
  bool isTarget = false;
  String myAmazonLink = "https://amzn.to/3AvWki6";
  String mywalmertLink = "https://walmart.com";
  String myTargetLink = "https://target.com";
  List<String> amazonLinkList = [];
  List<String> targetLinkList = [];
  List<String> walmartLinkList = [];
  int? currentindex;
  int? walmartIndex;
  int? targetINdex;
  String? amazon1;
  String? amazon2;
  String? amazon3;
  String? amazon4;
  String? walmart1;
  String? walmart2;
  String? walmart3;
  String? walmart4;
  String? target1;
  String? target2;
  String? target3;
  String? target4;
  void initState() {
    getdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          widget.isCheckScreen ? "Check your Funds" : "Buy Products",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.kprimeryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Amazon",
              onTap: () {
                _url = Uri.parse("https://affiliate-program.amazon.com/");
                widget.isCheckScreen == true
                    ? _launchUrl(_url!)
                    : buyProductButton(
                        amazonLinkList, myAmazonLink, currentindex, "index");
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              text: "Walmart",
              onTap: () {
                _url = Uri.parse("https://affiliates.walmart.com/");
                widget.isCheckScreen == true
                    ? _launchUrl(_url!)
                    : buyProductButton(walmartLinkList, mywalmertLink,
                        walmartIndex, "walmartIndex");
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              text: "Target",
              onTap: () {
                _url = Uri.parse("https://partners.target.com/");
                widget.isCheckScreen == true
                    ? _launchUrl(_url!)
                    : buyProductButton(targetLinkList, myTargetLink,
                        targetINdex, "targetINdex");
              },
            ),
          ],
        ),
      ),
    );
  }

  defultLinkOpen(String url) async {
    _url = Uri.parse(url);
    if (_url != null) {
      await _launchUrl(_url!);
    }
  }

  linkOpen(String url) async {
    _url = Uri.parse(url);
    if (_url != null) {
      await _launchUrl(_url!);
    }
  }

  getdata() async {
    preferences = await SharedPreferences.getInstance();
    amazon1 = preferences.getString("amazon1");
    amazon2 = preferences.getString("amazon2");
    amazon3 = preferences.getString("amazon3");
    amazon4 = preferences.getString("amazon4");
    target1 = preferences.getString("target1");
    target2 = preferences.getString("target2");
    target3 = preferences.getString("target3");
    target4 = preferences.getString("target4");
    walmart1 = preferences.getString("walmart1");
    walmart2 = preferences.getString("walmart2");
    walmart3 = preferences.getString("walmart3");
    walmart4 = preferences.getString("walmart4");
    currentindex = preferences.getInt("index");
    walmartIndex = preferences.getInt("walmartIndex");
    targetINdex = preferences.getInt("targetINdex");
    email = preferences.getString("email");
    name = preferences.getString("name");

    if (amazon1 != null) amazonLinkList.add(amazon1!);

    if (amazon2 != null) amazonLinkList.add(amazon2!);
    if (amazon3 != null) amazonLinkList.add(amazon3!);
    if (amazon4 != null) amazonLinkList.add(amazon4!);

    if (target1 != null) targetLinkList.add(target1!);
    if (target2 != null) targetLinkList.add(target2!);
    if (target3 != null) targetLinkList.add(target3!);
    if (target4 != null) targetLinkList.add(target4!);

    if (walmart1 != null) walmartLinkList.add(walmart1!);
    if (walmart2 != null) walmartLinkList.add(walmart2!);
    if (walmart3 != null) walmartLinkList.add(walmart3!);
    if (walmart4 != null) walmartLinkList.add(walmart4!);
  }

  buyProductButton(
      List<String>? list, String defultLink, int? index, String getInt) async {
    if (list!.isNotEmpty) {
      index = preferences.getInt(getInt);
      if (index != null) {
        if (list.length == 1) {
          if (index != 4) {
            linkOpen(list[0]);
            index = index + 1;
            preferences.setInt(getInt, index);
          } else {
            defultLinkOpen(defultLink);
            preferences.setInt(getInt, 0);
          }
        } else if (list.length == 2) {
          if (index != 4) {
            if (index.isOdd) {
              if(list[1] == '' || list[1] == null){
                defultLinkOpen(defultLink);
              }else{
                linkOpen(list[1]);
              }
            } else {
              if(list[0] == '' || list[0] == null){
                defultLinkOpen(defultLink);
              }else{
                linkOpen(list[0]);
              }

            }
            index = index + 1;
            preferences.setInt(getInt, index);
          } else {
            defultLinkOpen(defultLink);
            preferences.setInt(getInt, 0);
          }
        } else if (list.length == 3) {
          if (index == 0) {
            if(list[0] == '' || list[0] == null){
              defultLinkOpen(defultLink);
            }else{
              linkOpen(list[0]);
            }
            index = index + 1;
          } else if (index == 1) {
            if(list[1] == '' || list[1] == null){
              defultLinkOpen(defultLink);
            }else{
              linkOpen(list[1]);
            }
            index = index + 1;
          } else if (index == 2) {
            if(list[2] == '' || list[2] == null){
              defultLinkOpen(defultLink);
            }else{
              linkOpen(list[2]);
            }
            index = index + 1;
          } else if (index == 3) {
            if(list[0] == '' || list[0] == null){
              defultLinkOpen(defultLink);
            }else{
              linkOpen(list[0]);
            }
            index = index + 1;
          } else {
            defultLinkOpen(defultLink);
            index = 0;
          }

          preferences.setInt(getInt, index);
        } else if (list.length == 4) {
          if (index <= 4) {
            if (index == 0) {
              if(list[0] == '' || list[0] == null){
                defultLinkOpen(defultLink);
              }else{
                linkOpen(list[0]);
              }
              index = index + 1;
            } else if (index == 1) {
              if(list[1] == '' || list[1] == null){
                defultLinkOpen(defultLink);
              }else{
                linkOpen(list[1]);
              }
              index = index + 1;
            } else if (index == 2) {
              if(list[2] == '' || list[2] == null){
                defultLinkOpen(defultLink);
              }else{
                linkOpen(list[2]);
              }
              index = index + 1;
            } else if (index == 3) {
              if(list[3] == '' || list[3] == null){
                defultLinkOpen(defultLink);
              }else{
                linkOpen(list[3]);
              }
              index = index + 1;
            } else {
              defultLinkOpen(defultLink);
              index = 0;
            }

            await preferences.setInt(getInt, index);
          } else {
            defultLinkOpen(defultLink);
            await preferences.setInt(getInt, 0);
          }
        }
      } else {
        linkOpen(list[0]);
        preferences.setInt(getInt, 1);
      }
    } else {
      defultLinkOpen(defultLink);
    }
  }

  void linkSave(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (!await launchUrl(url)) {
        linkSave("Could not launch  $url");

        throw 'Could not launch $url';
      }
    } catch (e) {
      showCustomErrorDialog(
          context: context, text: "Something went wrong", title: "Message");
    }
  }

  showCustomErrorDialog({
    required String title,
    required String text,
    required BuildContext context,
  }) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
