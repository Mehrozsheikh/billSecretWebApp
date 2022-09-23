import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatbill/screens/platForm_select_screen.dart';
import 'package:whatbill/screens/promote_product_screen.dart';
import 'package:whatbill/screens/set_up_setting_button.dart';
import 'package:whatbill/screens/share_app_screen.dart';
import 'package:whatbill/screens/support_button.dart';
import '../Api_helper/ad_helper.dart';
import '../utils/color_constant.dart';
import '../widgets/web_cam.dart';
import 'explanation_screen.dart';
import 'get_affliaiate_links_screen.dart';
import 'get_started_screen.dart';
import 'my_shopping_army_screen.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences preferences;
  String? name;
  String? email;
  bool isAmazon = true;
  bool iswelmart = false;
  bool isTarget = false;
  String myAmazonLink = "https://amzn.to/3Aq9mOj";
  String mywalmertLink = "http://walmart.com";
  String myTargetLink = "http://target.com";
  List<String> amazonLinkList = [];
  List<String> targetLinkList = [];
  List<String> walmartLinkList = [];
  int? currentindex;
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
  Uri? _url;
  String? version;
  late BannerAd _bottomBannerAd;
  bool isBottomBannerAdd = false;
  bool isLoaded = true;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBottomBannerAdd = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(error.toString());
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    showVersionNumber();
    if (!kIsWeb) _createBottomBannerAd();
    getStrings();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getUpdateStatus();
  }

  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  void getStrings() async {
    preferences = await SharedPreferences.getInstance();
    email = preferences.getString("email");
    name = preferences.getString("name");
  }

  @override
  Widget build(BuildContext context) {
    getStrings();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: isBottomBannerAdd
          ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      body: Center(
        child: Container(

          // width: width * 0.7,
          child: Column(
            children: [
              //adsenseAdsView(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: const Text(
                        "BillSecret",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Column(
                      children: const [
                        Text("TM",
                            style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                        SizedBox(height: 10.0,)

                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Images/AppIcon.jpeg"))),
                    ),

                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name != null ? name! : "Name",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          email != null ? email! : "Email",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                     /*   const Text(
                          "Choose Platform",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            checkBox(
                                title: "Amazon",
                                selected: isAmazon,
                                onChanged: (value) {
                                  isAmazon = value!;
                                  iswelmart = false;
                                  isTarget = false;
                                  setState(() {});
                                }),
                            checkBox(
                              title: "Walmart",
                              selected: iswelmart,
                              onChanged: (value) {
                                iswelmart = value!;
                                isAmazon = false;
                                isTarget = false;
                                setState(() {});
                              },
                            ),
                            checkBox(
                              title: "Target",
                              selected: isTarget,
                              onChanged: (value) {
                                isTarget = value!;
                                iswelmart = false;
                                isAmazon = false;
                                // preferences.setInt("index", 0);
                                setState(() {});
                              },
                            )
                          ],
                        )*/
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: carddetailList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomCard(
                        onTap: () async {
                          if (kIsWeb) {
                            // if (kIsWeb) {
                            if (carddetailList[index].isLink != null) {
                              if (carddetailList[index].link != null) {
                                Uri _uri =
                                    Uri.parse(carddetailList[index].link!);
                                print("Button press");
                                _launchUrl(_uri);
                              }
                            }
                            // }
                            else {
                              await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              carddetailList[index].screen))
                                  .then((value) {
                                print("done");
                                setState(() {});
                              });
                            }
                          } else {
                            await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            carddetailList[index].screen))
                                .then((value) {
                              print("done");
                              setState(() {});
                            });
                          }
                        },
                        title: carddetailList[index].title,
                        imagePath: carddetailList[index].icon,
                      ),
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: () {
                        Uri uri = Uri.parse("https://icons8.com");
                        _launchUrl(uri);
                      },
                      child: const Text(
                        "https://icons8.com",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                 const SizedBox(width: 8.0,),
                  isLoaded
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'version:1.1.5',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                      : CircularProgressIndicator(
                    color: AppColor.kprimeryColor,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  getUpdateStatus() async {
    preferences = await SharedPreferences.getInstance();
    String getNextMonthDate = preferences.getString("NextDate")!;
    if (getNextMonthDate == DateFormat.yMMMMEEEEd().format(DateTime.now())) {
      showCustomErrorDialog(text: "Please update your app", title: "Message");
    } else {
      print("Not need to update");
    }
  }

  showCustomErrorDialog({
    required String title,
    required String text,
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

  Widget checkBox(
      {String? title,
      bool? selected,
      required void Function(bool?)? onChanged}) {
    return Row(
      children: [
        Checkbox(
            value: selected,
            activeColor: AppColor.kprimeryColor,
            onChanged: onChanged),
        Text(
          title!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
      ],
    );
  }

  final List<CardDetial> carddetailList = [
    CardDetial(
        icon: "assets/Images/icons8-commercial-100.png",
        title: "Promote Products",
        screen: PromoteProduct(),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-shouting-100.png",
        title: "Share App",
        screen: ShareAppScreen(),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-man-with-money-100.png",
        title: "Check Your Funds",
        // isLink: ,
        screen: PlatformSelectionScreen(
          isCheckScreen: true,
        ),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-shopping-bag-100.png",
        title: "Buy Products",
        // isbuyProduct: true,
        screen: PlatformSelectionScreen(
          isCheckScreen: false,
        ),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-organization-chart-people-100.png",
        title: "My Shopping Army",
        screen: MyShoppingArmy(qrData: 'https://pub.dev/packages/qr_flutter'),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-helping-100.png",
        title: "Support",
        screen: SupportScreen(
          isSupportScreen: true,
        ),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-flipboard-100.png",
        title: "App Explanation",
        link:
            "https://www.mediafire.com/file/ucuwhrod1ngrjoi/BillSecretApp-Explanation-REVISED.mp4/file",
        isLink: true,
        screen: CustomVideoPlayer(
          url:
              'https://www.mediafire.com/file/ucuwhrod1ngrjoi/BillSecretApp-Explanation-REVISED.mp4/file',
        ),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-to-do-100.png",
        title: "Getting Started",
        screen: const GettingStarted(),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-ratings-100.png",
        title: "Strategy Guide",
        screen: Container(),
        isLink: true,
        link: "https://sites.google.com/view/billsecret-strategy-guide/home",
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-charity-100.png",
        title: "Charity",
        screen: SupportScreen(
          isSupportScreen: false,
        ),
        route: ""),
    CardDetial(
        icon: "assets/Images/icons8-tasks-100.png",
        title: "Set Up Settings",
        screen: SetUPSettingScreen(),
        route: ""),
    CardDetial(
        icon: "assets/Images/internet.png",
        title: "Get Affiliate Links",
        screen: const GetAffliateLInk(),
        route: ""),
    CardDetial(
        icon: "assets/Images/scan.png",
        title: "Scan Qr ",
        screen: const WebcamApp(),
        route: ""),
  ];

  Future<void> showVersionNumber() async {
    isLoaded = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.buildNumber;
    isLoaded = true;
  }
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final void Function()? onTap;
  const CustomCard({
    required this.onTap,
    required this.imagePath,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xff80cbc4),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 0.3,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: Image.asset(
                imagePath,
                // color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetial {
  String title = '';
  String route = '';
  String icon = '';
  String? link;
  Widget screen;
  bool? isLink;
  bool? isbuyProduct;

  CardDetial({
    required this.screen,
    this.isLink,
    this.isbuyProduct,
    this.link,
    required this.icon,
    required this.route,
    required this.title,
  });
}
