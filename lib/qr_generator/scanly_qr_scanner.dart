import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanly/image_manager/scanly_image_manager.dart';

class ScanlyQRScanner extends StatefulWidget {
  const ScanlyQRScanner({Key? key, required this.onScanData}) : super(key: key);
  final Function(String?) onScanData;

  @override
  State<ScanlyQRScanner> createState() => _ScanlyQRScannerState();
}

class _ScanlyQRScannerState extends State<ScanlyQRScanner> {
  List<ImageModel> images = [];

  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;

  @override
  void initState() {
    getRecent();
    super.initState();
  }

  Future<void> getRecent() async {
    images = await ScanlyImageManager.getRecentImages();
    images.add(ImageModel(
      type: Type.gallery,
      file: File(''),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Positioned(
          child: PhotoSlider(images, widget.onScanData),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream
        .listen((scanData) => widget.onScanData.call(scanData.code));
  }
}

class PhotoSlider extends StatelessWidget {
  const PhotoSlider(this.images, this.onScanData, {Key? key}) : super(key: key);
  final List<ImageModel> images;
  final Function? onScanData;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      height: 130 + 25,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => images[index].type == Type.gallery ? ChooseFromGalleryOption(onScanData!) : PhotoItem(images[index].file!, onScanData!),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 12),
        itemCount: images.length,
      ),
    );
  }
}

class ChooseFromGalleryOption extends StatelessWidget {
  const ChooseFromGalleryOption(this.onScanData, {Key? key}) : super(key: key);
  final Function onScanData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
          String? result = await ScanlyImageManager.scan(image!.path);
          onScanData.call(result ?? '');
        } catch (e) {
          log("Scanly: Unexpected Error Occurred!");
          log("Scanly Error: $e");
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: 130,
        decoration: const BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.image, color: Colors.white, size: 30,),
      ),
    );
  }
}

class PhotoItem extends StatelessWidget {
  const PhotoItem(this.image, this.onScanData, {Key? key}) : super(key: key);
  final File image;
  final Function onScanData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String? result = await ScanlyImageManager.scan(image.path);
        onScanData.call(result);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          image: DecorationImage(
            image: FileImage(image),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
