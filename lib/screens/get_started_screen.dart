import 'package:flutter/material.dart';

import '../utils/color_constant.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColor.kprimeryColor,
        title: const Text(
          "Get Started ",
          style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600,
            // fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            checkList(
                title:
                    "Create your Affiliate accounts with Amazon, Walmart and Target."),
            const SizedBox(
              height: 20,
            ),
            checkList(
                title:
                    "Build a Huge Shopping Army by telling people to download the app and to enter your affiliate link into their version of the app. (Remember, when they shop, they don’t pay any more for the product but you get paid for their shopping. You have a better chance of getting them to put your affiliate link in when you are the one telling them about the app.) Get in first because others will try to get your supporters to put their affiliate link into the rotation and they only have 9 spots to leverage. Get in while those spots mean little to them. Make consistent money automatically."),
            const SizedBox(
              height: 20,
            ),
            checkList(
                title:
                    "Promote products to your family, friends and following. Use your knowledge of them to target what they would like."),
          ],
        ),
      ),
    );
  }

  Widget checkList({String? title}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 22,
          child: Checkbox(
            value: true,
            activeColor: AppColor.kprimeryColor,
            onChanged: (bool? value) {},
          ),
        ),
        Expanded(
          child: Text(
            title!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
