import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Site Photo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  height: 400,
                  width: 400,
                  child: CameraPreview(controller),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  pictureFile = await controller.takePicture();
                  setState(() {});
                },
                child: const Text('Capture Image'),
              ),
            ),
            pictureFile != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.file(File(pictureFile!.path),
                            width: 400, height: 400),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // // save to device
                                  final File image = File(pictureFile!.path);

                                  await GallerySaver.saveImage(image.path,
                                      albumName: 'HHU_Helper');

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      'Download to HHU_Helper folder',
                                    ),
                                  ));
                                },
                                child: const Text('Save Image'),
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () async {
                                  pictureFile = await controller.takePicture();
                                  setState(() {});
                                },
                                child: const Text('Cancel'),
                              ),
                            ]),
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8),
                  ),
          ],
        ),
      ),
    );
  }
}
