import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanly/image_manager/scanly_image_manager.dart';

class Scanly extends StatefulWidget {
  const Scanly({Key? key, this.onScanData}) : super(key: key);
  final Function? onScanData;

  @override
  State<Scanly> createState() => _ScanlyState();
}

class _ScanlyState extends State<Scanly> {
  List<ImageModel> images = [];

  final GlobalKey qrKey = GlobalKey();
  Barcode? result;
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
          child: PhotoSlider(images),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream
        .listen((scanData) => widget.onScanData!.call(scanData));
  }
}

class PhotoSlider extends StatelessWidget {
  PhotoSlider(this.images, {Key? key}) : super(key: key);
  final List<ImageModel> images;

  double size = 100;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      height: size + 12,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12) +
              const EdgeInsets.only(bottom: 12),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              images[index].type == Type.gallery
                  ? ChooseFromGalleryOption(size)
                  : PhotoItem(size, images[index].file!),
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
                width: 12,
              ),
          itemCount: images.length),
    );
  }
}

class ChooseFromGalleryOption extends StatelessWidget {
  const ChooseFromGalleryOption(this.size, {Key? key}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => log('choose image'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: size,
        decoration: const BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: const Center(
          child: Text(
            'choose from galley',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class PhotoItem extends StatelessWidget {
  const PhotoItem(this.size, this.image, {Key? key}) : super(key: key);
  final double size;
  final File image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => log('go to image'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
