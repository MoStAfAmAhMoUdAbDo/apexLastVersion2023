import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class Qr_scanner extends StatefulWidget {
  const Qr_scanner({super.key});
  static const rout = '/qr_scane';

  @override
  State<Qr_scanner> createState() => _Qr_scannerState();
}

class _Qr_scannerState extends State<Qr_scanner> {
  GlobalKey qrkey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  late Size size;
  var result_qr;
  bool flash_togl = true;
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: buildQrview(context)),
              //Positioned(bottom: 10, child: buildresult()),
              // Positioned(top : 10 ,child: flibthecamera()),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              setState(() {
                                flash_togl = !flash_togl;
                              });
                              await controller?.toggleFlash();
                            },
                            icon: flash_togl
                                ? const Icon((Icons.flash_off))
                                :const  Icon(Icons.flash_on),
                          ),
                          IconButton(
                              onPressed: () async {
                                await controller!.flipCamera();
                                setState(() {});
                              },
                              icon:const  Icon(Icons.flip_camera_ios)),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // controller?.pauseCamera();

                            setState(() {
                              controller?.pauseCamera();
                            });
                            //Navigator.pushReplacementNamed(context, Main_Screen.rout);
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Main_Screen()));
                            Navigator.of(context).pop();
                            //Navigator.of(context).pushNamedAndRemoveUntil(Main_Screen.rout, (route) => false);
                          },
                          child:const Text(
                            "cancel",
                            style:  TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQrview(BuildContext context) {
    return QRView(
      key: qrkey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue,
        borderRadius: 10,
        borderWidth: 10,
        borderLength: 20,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  // Widget buildresult() {
  //   return Container(
  //     padding: EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8), color: Colors.white),
  //     child: Text(barcode != null
  //         ? 'result is ${barcode!.code}'
  //         : 'scan the barcode again'),
  //   );
  // }

  // Widget flibthecamera() {
  //   return Center(
  //     child: IconButton(
  //         onPressed: () async {
  //           await controller!.flipCamera();
  //           setState(() {});
  //         },
  //         icon: Icon(Icons.flip_camera_android)),
  //   );
  // }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
        result_qr = barcode.code;
        controller.pauseCamera();
      });
      if (result_qr != null) {
        //Navigator.pushReplacementNamed(context, Main_Screen.rout,arguments: result_qr);
        //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Persistent_nav_Bar()));
        Navigator.of(context).pop(result_qr);
        //Navigator.of(context).pushNamedAndRemoveUntil(Main_Screen.rout, (route) => false ,arguments: result_qr); remove all rootes and set the root i  specified in the stack

        controller.stopCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
