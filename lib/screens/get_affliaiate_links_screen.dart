import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whatbill/utils/color_constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/customButton.dart';

class GetAffliateLInk extends StatelessWidget {
  const GetAffliateLInk({Key? key}) : super(key: key);
  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Get Affiliate Links",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColor.kprimeryColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Amazon",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                    "1  Set Up For Receiving - Go To Amazon’s Affiliate Sign Up Page and sign up. Choose social media as your means of promoting your links."),
                Text("Amazon.com Associates Central"),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "2  After you have created your affiliate account go to www.amazon.com and log into your buyer’s account directly. And use the toolbar that now shows at the top of your screen to grab the affiliate link for the main page."),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "3  Click the word “Text” and grab the affiliate link that appears in the text box in orange. That is your affiliate link to get as many people as you can to put your link in their app and feed you money. Remember, you need to get to people first to get them to put your affiliate link in. Each person can put in up to 5 people’s affiliate links but you want to be first and hope that you are the only one for each of your friends app because your affiliate link will be rotated with up to 4 others if not. You still make money but you want to get paid on every purchase of your friends and family."),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Amazon",
                    onTap: ()  {
                      Uri _uri =
                      Uri.parse("https://affiliate-program.amazon.com");
                      _launchUrl(_uri);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Walmart",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("press on button and get Alliliate link"),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Walmart",
                    onTap: ()  {
                      Uri _uri = Uri.parse("https://affiliates.walmart.com");
                      _launchUrl(_uri);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Target",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("press on button and get Alliliate link"),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Target",
                    onTap: ()  {
                      Uri uri = Uri.parse("https://partners.target.com");
                      _launchUrl(uri);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customButton({String? buttonName, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          height: 70,
          width: 220,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.kprimeryColor,
              ),
          child: Text(buttonName!,style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
