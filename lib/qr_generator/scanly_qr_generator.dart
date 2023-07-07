import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScanlyQRGenerator extends StatelessWidget {

  ScanlyQRGenerator({
    Key? key,
    required this.data,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor,
    this.size,
    this.circled = false,
    this.embeddedImage,
    this.padding = const EdgeInsets.all(10),
  }) : assert(data.trim().isNotEmpty), super(key: key);

  final String data;
  final Color backgroundColor;
  final Color? foregroundColor;
  final bool circled;
  final double? size;
  final EdgeInsets padding;
  final ImageProvider? embeddedImage;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      size: size,
      padding: padding,
      eyeStyle: QrEyeStyle(
        eyeShape: circled ? QrEyeShape.circle : QrEyeShape.square,
        color: foregroundColor ?? Colors.black,
      ),
      embeddedImage: embeddedImage,
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: circled ? QrDataModuleShape.circle : QrDataModuleShape.square,
        color: foregroundColor ?? Colors.black,
      ),
    );
  }
}
