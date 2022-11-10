import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class nameScreen extends StatefulWidget {
  @override
  State<nameScreen> createState() => _nameScreenState();
}

class _nameScreenState extends State<nameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(
              facing: CameraFacing.front, torchEnabled: true),
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              debugPrint('Barcode found! $code');
            }
          }),
    );
  }
}
