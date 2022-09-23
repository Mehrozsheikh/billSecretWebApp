import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:whatbill/utils/color_constant.dart';

class Strategy_guid_screen extends StatefulWidget {
  const Strategy_guid_screen({Key? key}) : super(key: key);

  @override
  State<Strategy_guid_screen> createState() => _Strategy_guid_screenState();
}

class _Strategy_guid_screenState extends State<Strategy_guid_screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.kprimeryColor,
        title: const Text(
          "Strategy Guide",
          style: TextStyle(
            color: Colors.black,
            // fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: kIsWeb
              ? SfPdfViewer.network(
                  'https://sites.google.com/view/billsecret-strategy-guide/home')
              : SfPdfViewer.asset('assets/Images/BillSecret.pdf'),
        ),
      ),
    );
    ;
  }
}
