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
  }) : assert(data.trim().isNotEmpty), super(key: key);

  final String data;
  final Color backgroundColor;
  final Color? foregroundColor;
  final bool circled;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: data,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      size: size,
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: circled ? QrDataModuleShape.circle : QrDataModuleShape.square,
      ),
    );
  }
}