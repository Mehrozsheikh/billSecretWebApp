import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home.dart';
import '../utils/Helper.dart';
import '../utils/color_constant.dart';

class WebcamApp extends StatelessWidget {
  const WebcamApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WebcamPage(),
      );
}

class WebcamPage extends StatefulWidget {
  const WebcamPage({Key? key}) : super(key: key);

  @override
  _WebcamPageState createState() => _WebcamPageState();
}

class _WebcamPageState extends State<WebcamPage> {
  // Webcam widget to insert into the tree
  MobileScannerController cameraController = MobileScannerController();
  SharedPreferences storeList = sharedPreferences;
  Map<String, dynamic>? value = null;

  @override
  void dispose() {
    cameraController.stop();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    cameraController.stop();
    return (await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            ModalRoute.withName("/Home"))) ??
        false;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  cameraController.stop();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      ModalRoute.withName("/Home"));
                },
              ),
              backgroundColor: AppColor.kprimeryColor,
              title: const Text(
                'Scan Qr',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: cameraController.torchState,
                    builder: (context, state, child) {
                      switch (state as TorchState) {
                        case TorchState.off:
                          return const Icon(Icons.flash_off,
                              color: Colors.grey);
                        case TorchState.on:
                          return const Icon(Icons.flash_on,
                              color: Colors.yellow);
                      }
                    },
                  ),
                  iconSize: 32.0,
                  onPressed: () => cameraController.toggleTorch(),
                ),
                IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: cameraController.cameraFacingState,
                    builder: (context, state, child) {
                      switch (state as CameraFacing) {
                        case CameraFacing.front:
                          return const Icon(Icons.camera_front);
                        case CameraFacing.back:
                          return const Icon(Icons.camera_rear);
                      }
                    },
                  ),
                  iconSize: 32.0,
                  onPressed: () => cameraController.switchCamera(),
                ),
              ],
            ),
            body: Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: MobileScanner(
                    allowDuplicates: false,
                    controller: cameraController,
                    onDetect: (barcode, args) {
                      if (barcode.rawValue == null) {
                        print('Not found');
                        debugPrint('Failed to scan Barcode');
                      } else {
                        final String code = barcode.rawValue!;
                        value = json.decode(code);
                        String type = value!['urlType'];
                        if (type == 'amazon') {
                          String? amazon1 = storeList.getString("amazon1");
                          String? amazon2 = storeList.getString("amazon2");
                          String? amazon3 = storeList.getString("amazon3");
                          String? amazon4 = storeList.getString("amazon4");
                          if (amazon1 != null &&
                              amazon2 != null &&
                              amazon3 != null &&
                              amazon4 != null && amazon1 !='' &&  amazon2 !='' &&  amazon3 !='' &&  amazon4 !='') {
                            showWarningMessage("Amazon");
                          }else{
                            showAlertDialog(context, code);
                          }

                        }else if (type == 'walmart') {
                          String? walmart1 = storeList.getString("walmart1");
                          String? walmart2 = storeList.getString("walmart2");
                          String? walmart3 = storeList.getString("walmart3");
                          String? walmart4 = storeList.getString("walmart4");
                          if (walmart1 != null  && walmart2 != null && walmart3 != null
                              && walmart4 != null && walmart2 !='' && walmart1 !=''&& walmart3 !='' && walmart4 !='') {
                            showWarningMessage("Walmart");
                          }else{
                            showAlertDialog(context, code);
                          }
                        } else if (type == 'target') {
                          String? target1 = storeList.getString("target1");
                          String? target2 = storeList.getString("target2");
                          String? target3 = storeList.getString("target3");
                          String? target4 = storeList.getString("target4");
                          if (target1 != null &&
                              target2 != null &&
                              target3 != null &&
                              target4 != null && target1 !='' && target2!='' && target3 !='' && target4 !='') {
                            showWarningMessage("Target");

                          }else{
                            showAlertDialog(context, code);
                          }
                        }

                      }
                    }),
              ),
            )),
      );

  showAlertDialog(BuildContext context, String QrCode) {
    // set up the buttons
    Widget cancelButton = TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
        backgroundColor: MaterialStateProperty.all(
          Colors.green,
        ),
        minimumSize: MaterialStateProperty.all(Size(20, 10)),
      ),
      child: const Text(
        'Yes',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white),
      ),
      onPressed: () {
        value = json.decode(QrCode);
        print(value);
        String type = value!['urlType'];

        if (type == 'amazon') {
          String? amazon1 = storeList.getString("amazon1");
          String? amazon2 = storeList.getString("amazon2");
          String? amazon3 = storeList.getString("amazon3");
          String? amazon4 = storeList.getString("amazon4");
          if (amazon1 == null &&
              amazon2 == null &&
              amazon3 == null &&
              amazon4 == null) {
            storeList.setString('amazon1', value!['url']);
          } else if (amazon1 == null || amazon1  == '') {
            storeList.setString('amazon1', value!['url']);
          } else if (amazon2 == null  || amazon2  == '') {
            storeList.setString('amazon2', value!['url']);
          } else if (amazon3 == null || amazon3  == '') {
            storeList.setString('amazon3', value!['url']);
          } else if (amazon4 == null || amazon4  == '') {
            storeList.setString('amazon4', value!['url']);
          } else {
            storeList.setString('amazon1', value!['url']);
          }
        } else if (type == 'walmart') {
          String? walmart1 = storeList.getString("walmart1");
          String? walmart2 = storeList.getString("walmart2");
          String? walmart3 = storeList.getString("walmart3");
          String? walmart4 = storeList.getString("walmart4");
          if (walmart1 == null &&
              walmart2 == null &&
              walmart3 == null &&
              walmart4 == null) {
            storeList.setString('walmart1', value!['url']);
          } else if (walmart1 == null) {
            storeList.setString('walmart1', value!['url']);
          } else if (walmart2 == null || walmart2 == '') {
            storeList.setString('walmart2', value!['url']);
          } else if (walmart3 == null || walmart3 == '' ) {
            storeList.setString('walmart3', value!['url']);
          } else if (walmart4 == null || walmart4 == '') {
            storeList.setString('walmart4', value!['url']);
          } else {
            storeList.setString('walmart1', value!['url']);
          }
        } else {
          String? target1 = storeList.getString("target1");
          String? target2 = storeList.getString("target2");
          String? target3 = storeList.getString("target3");
          String? target4 = storeList.getString("target4");
          if (target1 == null &&
              target2 == null &&
              target3 == null &&
              target4 == null) {
            storeList.setString('target1', value!['url']);
          } else if (target1 == null || target1  == '') {
            storeList.setString('target1', value!['url']);
          } else if (target2 == null  || target2  == '') {
            storeList.setString('target2', value!['url']);
          } else if (target3 == null  || target3  == '') {
            storeList.setString('target3', value!['url']);
          } else if (target4 == null  || target4  == '') {
            storeList.setString('target4', value!['url']);
          } else {
            storeList.setString('target1', value!['url']);
          }
        }
        linkSave();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(4.0)),
        backgroundColor: MaterialStateProperty.all(
          Colors.red,
        ),
        minimumSize: MaterialStateProperty.all(Size(15, 6.0)),
      ),
      child:
          const Text("No", style: TextStyle(fontSize: 15, color: Colors.white)),
      onPressed: () {
        setState(() {
          cameraController.start();

          Navigator.of(context, rootNavigator: true).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert..."),
      content: const Text("Would you like to Enter Into your support"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void linkSave() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Saved "),
    ));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
        ModalRoute.withName("/Home"));
    cameraController.stop();
  }

  void showWarningMessage(String Type) {
    // set up the buttons
    Widget cancelButton = TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
        backgroundColor: MaterialStateProperty.all(
          Colors.green,
        ),
        minimumSize: MaterialStateProperty.all(Size(20, 10)),
      ),
      child: const Text(
        'Ok',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            ModalRoute.withName("/Home"));
        cameraController.stop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert..."),
      content: Text(
          "Sorry No Spots Available \n please remove one link from $Type Area"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
