import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatbill/utils/color_constant.dart';
import 'package:whatbill/widgets/customButton.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class PromoteProduct extends StatefulWidget {
  PromoteProduct({Key? key}) : super(key: key);

  @override
  State<PromoteProduct> createState() => _PromoteProductState();
}

class _PromoteProductState extends State<PromoteProduct> {
  bool value = false;
  String? amazonMessage;
  String? targetMessage;
  String? walmartMessage;
  late SharedPreferences preferences;
  List<Contact>? _contacts;
  List<String> _addContacts = [];
  bool _permissionDenied = false;

  TextEditingController message = TextEditingController();
  bool isAmazon = false;
  bool iswelmart = false;
  bool isTarget = false;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _fetchContacts();
    getData();
  }

  getData() async {
    preferences = await SharedPreferences.getInstance();
    amazonMessage = preferences.getString("amazon");
    walmartMessage = preferences.getString("walmart");
    targetMessage = preferences.getString("target");
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
      _contacts = [];
    } else {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withAccounts: true, withPhoto: true);
      setState(() => _contacts = contacts);
    }
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
        title: const Text(
          "Promote Products",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.kprimeryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  checkBox(
                      title: "Amazon",
                      selected: isAmazon,
                      onChanged: (value) {
                        if (amazonMessage != null) {
                          message.text = amazonMessage!;
                        }
                        isAmazon = value!;
                        iswelmart = false;
                        isTarget = false;
                        setState(() {});
                      }),
                  checkBox(
                    title: "Walmart",
                    selected: iswelmart,
                    onChanged: (value) {
                      if (walmartMessage != null) {
                        message.text = walmartMessage!;
                      }
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
                      if (targetMessage != null) {
                        message.text = targetMessage!;
                      }
                      isTarget = value!;
                      iswelmart = false;
                      isAmazon = false;
                      setState(() {});
                    },
                  )
                ],
              ),
              const CustomHeading(
                title: "Message",
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                  width: 1,
                )),
                child: TextFormField(
                  controller: message,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Message",
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomHeading(
                title: "Contacts",
              ),
              const SizedBox(
                height: 20,
              ),
              if (!kIsWeb)
                _contacts != null
                    ? SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: _contacts!.length,
                            itemBuilder: (context, i) => Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: SizedBox(
                                    height: 20,
                                    width: double.infinity,
                                    child: CustomCheckbox(
                                      value: isSelected,
                                      addContacts: _addContacts,
                                      phoneNumber:
                                          _contacts![i].phones.isNotEmpty
                                              ? _contacts![i].phones[0].number
                                              : "",
                                      title: _contacts!.isNotEmpty
                                          ? _contacts![i].displayName.isNotEmpty
                                              ? _contacts![i].displayName
                                              : ""
                                          : "",
                                      onChanged: (n) {
                                        setState(() {
                                          this.value = n!;
                                        });
                                      },
                                    ),
                                  ),
                                )),
                      )
                    : const Center(child: CircularProgressIndicator()),
              const SizedBox(
                height: 20,
              ),
              if (kIsWeb)
                CustomButton(
                  onTap: () async {
                    if (message.text.isNotEmpty) {
                      linkSave("Copied");
                      Clipboard.setData(ClipboardData(text: message.text));
                    } else {
                      linkSave("Please write a message");
                    }
                  },
                  text: "Copy Message",
                ),
              if (!kIsWeb)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: CustomButton(
                        onTap: () async {
                          if (message.text.isNotEmpty) {
                            await _sendSMS(
                                message: message.text, recipents: _addContacts);
                          } else {
                            linkSave("Please write a message");
                          }
                        },
                        text: "Text",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: CustomButton(
                        onTap: () async {
                          if (message.text.isNotEmpty) {
                            launchEmail(message.text);
                          } else {
                            linkSave("Please write a message");
                          }
                        },
                        text: "Email",
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: "Facebook",
                    onTap: () async {
                      Uri _uri = Uri.parse("https://www.facebook.com");
                      await _launchUrl(_uri);
                    },
                  ),
                  CustomButton(
                    text: "Insatgram",
                    onTap: () async {
                      Uri _uri = Uri.parse("https://www.instagram.com/");
                      await _launchUrl(_uri);
                    },
                  ),
                  CustomButton(
                    text: "Twitter",
                    onTap: () async {
                      Uri _uri = Uri.parse("https://twitter.com");
                      await _launchUrl(_uri);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void linkSave(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  launchEmail(String message) async {
    // ios specification
    final String subject = "Subject:";
    final String stringText = message;
    String uri =
        'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print("No email client found");
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void launchEmailSubmission() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'nabeelyousaf1995@gmail.com',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
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
          onChanged: onChanged,
        ),
        Text(
          title!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  _sendSMS({String? message, List<String>? recipents}) async {
    String result = await sendSMS(message: message!, recipients: recipents!)
        .catchError((onError) {
      print(onError);
    });
    print(result);
  }
}

class CustomHeading extends StatelessWidget {
  final String title;
  const CustomHeading({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  String title;
  String? phoneNumber;
  String? selectedProduct;

  void Function(bool?)? onChanged;
  bool? value;
  List<String>? addContacts = [];
  String? messageLink;

  CustomCheckbox({
    required this.title,
    this.selectedProduct,
    this.phoneNumber,
    this.addContacts,
    this.value,
    this.onChanged,
    this.messageLink,
    Key? key,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool value = false;
  String? amazonLink;
  String? walmartLink;
  String? targetLink;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    amazonLink = sharedPreferences.getString("amazonlink");
    walmartLink = sharedPreferences.getString("walmartLink");
    targetLink = sharedPreferences.getString("targetLink");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AppColor.kprimeryColor,
          onChanged: (bool? value) {
            widget.messageLink = "amam";
            this.value = value!;

            setState(() {
              if (widget.addContacts != null) {
                if (this.value) {
                  widget.addContacts!.add(widget.phoneNumber!);
                } else {
                  if (widget.addContacts!.contains(widget.phoneNumber!)) {
                    widget.addContacts!.remove(widget.phoneNumber!);
                  }
                }
              }
              if (widget.selectedProduct != null) {
                print(widget.selectedProduct);
              }
            });
          },
        ),
        Expanded(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
