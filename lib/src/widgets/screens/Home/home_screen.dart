import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:hhu_helper/src/core/app_styles.dart';
import 'package:hhu_helper/src/core/size_config.dart';
import 'package:hhu_helper/src/widgets/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("HHU Helper"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: kPaddingHorizontal * 2, horizontal: kPaddingHorizontal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuTile(
              onTap: () {
                Navigator.pushNamed(context, '/reading');
              },
              text: "Readings",
              icon: const Icon(Icons.list_alt, size: 49, color: kWhiteColor),
              bgColor: kLimeColor,
            ),
            MenuTile(
              onTap: () async {
                await availableCameras().then(
                  (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraPage(
                                cameras: value,
                              ))),
                  // (value) => Navigator.pushNamed(context, '/camera', cameras: value,),
                );
              },
              text: "Field Photo",
              icon: const Icon(Icons.camera_alt, size: 49, color: kWhiteColor),
              bgColor: kBlueColor,
            ),
            MenuTile(
              onTap: () {
                Navigator.pushNamed(context, '/qr');
              },
              text: "Scan QR",
              icon: const Icon(Icons.qr_code_scanner,
                  size: 49, color: kWhiteColor),
              bgColor: kAmberColor,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final onTap;
  final String text;
  final Color bgColor;
  final Icon icon;
  const MenuTile({
    required this.onTap,
    required this.text,
    required this.bgColor,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: bgColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                text,
                textAlign: TextAlign.center,
                style: kQuestrialSemibold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 5,
                    color: kWhiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
