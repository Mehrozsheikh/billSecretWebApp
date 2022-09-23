import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImageWithTitle extends StatelessWidget {
  final String Link;
  final String title;
  final GestureTapCallback cancelClick;
  final GestureTapCallback QrClick;
  const QrImageWithTitle(this.Link, this.title,this.cancelClick,this.QrClick ,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: cancelClick,
                child: Icon(
              Icons.cancel,
              size: 30,
            )),
            Column(
              children: [
                InkWell(
                  onTap: QrClick,
                  child: QrImage(
                    data: Link == '' ? "Hello World" : Link,
                    version: QrVersions.auto,
                    size: 180,
                    gapless: false,
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
