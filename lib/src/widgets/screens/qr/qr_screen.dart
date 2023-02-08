import 'package:hhu_helper/src/data/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Scan  User Id "),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
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
      body: MobileScanner(
          allowDuplicates: true,
          controller: cameraController,
          onDetect: _foundbarCode),
    );
  }

  _foundbarCode(Barcode barcode, MobileScannerArguments? args) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);

    /// open screen
    if (!_screenOpened) {
      final String code = barcode.rawValue ?? "---";
      // logic to check if id is in the list of users
      // TODO : 1. get list of all users and extract their ids
      var ids = [];
      var users = provider.fetchReadingByID(code);

      // TODO : 2. check if current code is in the list of ids
      // final bool _productIsInList =
      //       _checkoutList.any((product) => product.name == getSelectedProduct.name);
      //   if (_productIsInList) {
      //     // Do what you want to do if the list contains the product
      //   } else {
      //     // Do what you want to do if the list contains the product
      //   }

      // TODO : 1. show error
      // TODO : 2. pause for 5 seconds or return to scan again
      // if (code == widget.userId.toString()) {
      //   // ^ GOTO OUR UPDATE PAGE
      //   Navigator.pushNamed(context, '/edit_user', arguments: widget.userId);
      // } else {

      // ^ SHOW ERROR SNACK AND RETURN TO LIST
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: CustomSnackBar(
      //     cardColor: Color(0xFFC72C41),
      //     bubbleColor: Color(0xFF801336),
      //     title: "Oh Snap",
      //     message: "No it is not our id",
      //   ),
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ));
      // }
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}





















// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRScreen extends StatefulWidget {
//   const QRScreen({super.key});

//   @override
//   State<QRScreen> createState() => _QRScreenState();
// }

// class _QRScreenState extends State<QRScreen> {
//   final qrkey = GlobalKey(debugLabel: 'QR');
//   var flashOn = false;

//   QRViewController? controller;
//   Barcode? barcode;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   void reassemble() async {
//     super.reassemble();

//     if (Platform.isAndroid) {
//       await controller!.pauseCamera();
//     }

//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan a QR Code"),
//         centerTitle: true,
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           buildQrView(context),
//           Positioned(
//             bottom: 10,
//             child: buildResult(),
//           ),
//           Positioned(
//             top: 10,
//             child: buildControlButtons(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildQrView(BuildContext context) => QRView(
//         key: qrkey,
//         onQRViewCreated: onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//           cutOutSize: MediaQuery.of(context).size.width * 0.8,
//           borderRadius: 10,
//           borderWidth: 10,
//           borderLength: 20,
//           borderColor: Colors.blue,
//         ),
//       );

//   void onQRViewCreated(QRViewController controller) {
//     setState(() => this.controller = controller);

//     controller.scannedDataStream.listen(
//       (barcode) => setState(() {
//         this.barcode = barcode;
//       }),
//     );
//   }

//   Widget buildResult() => Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white24,
//         ),
//         child: Text(
//           barcode != null ? 'Result : ${barcode!.code}' : 'scan a code!',
//           maxLines: 3,
//         ),
//       );

//   Widget buildControlButtons() => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white24,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             IconButton(
//               onPressed: () async {
//                 await controller?.toggleFlash();
//                 setState(() {
//                   flashOn = !flashOn;
//                 });
//               },
//               icon: flashOn
//                   ? const Icon(Icons.flash_on)
//                   : const Icon(Icons.flash_off),
//             ),
//           ],
//         ),
//       );
// }
