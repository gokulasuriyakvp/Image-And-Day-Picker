import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttter_image_day_pickers/display_image.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'appdata.dart';

import 'indicator.dart';

class PageViewImage extends StatefulWidget {
  const PageViewImage({Key? key}) : super(key: key);

  @override
  _PageViewImageState createState() => _PageViewImageState();
}

class _PageViewImageState extends State<PageViewImage> {
  int _selectedIndex = 0;
  List<Appdata> appdatalist = [
    Appdata('images/birdimage.jpeg'),
    Appdata('images/quotes6.jpg'),
    //Appdata('assets/your_asset_image.jpg'), // Replace with your asset image path
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directory Images', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
                [PopupMenuItem(value: 1, child: Text('Share'))],
            onSelected: (value) {
              if (value == 1) {
                _share();
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: 400,
              height: 400,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                itemCount: appdatalist.length,
                itemBuilder: (context, index) {
                  return DisplayImage(appdata: appdatalist[index]);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  appdatalist.length,
                  (index) => Indicator(
                    isActive: _selectedIndex == index,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _share() async {
    final ByteData imageByte =
        await rootBundle.load(appdatalist[_selectedIndex].image);
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/download.jpg';
    File(path).writeAsBytesSync(imageByte.buffer.asUint8List(), flush: true);
    await Share.shareFiles([path], text: 'Image shared');
  }
}
