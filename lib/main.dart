import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lista_embarques/mapa.dart';
import 'package:lista_embarques/scanner.dart';
import 'package:location/location.dart';
import 'package:qrscan/qrscan.dart' as scanner;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  Location location = new Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.granted;
  LocationData _locationData = LocationData.fromMap({});
}

class _MyAppState extends State<MyApp> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  DateTime now = DateTime.now();
  String? locacion = "";
  String ubicacion = "";
  List _personas = [
    Persona("Rut: 1239999", "Ubicación: 123328917-1238979321",
        "Fecha y hora: 24-09-2022 01:13"),
    Persona("Rut: 1239999", "Ubicación: 123328917-1238979321",
        "Fecha y hora: 24-09-2022 01:13"),
    Persona("Rut: 1239999", "Ubicación: 123328917-1238979321",
        "Fecha y hora: 24-09-2022 01:13"),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: Color.fromARGB(255, 192, 146, 18),
      )),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Lista de embarque'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.qr_code_scanner_rounded),
                onPressed: () async {
                  String barcodeScanRes =
                      await FlutterBarcodeScanner.scanBarcode(
                          '#3D8BEF', 'Cancelar', false, ScanMode.QR);
                  print(barcodeScanRes);

                  void scanQr() async {
                    // String cameraScanResult = await scanner.scan().toString();
                    // print(cameraScanResult);
                    setState(() {
                      List<String> searchKeywords = List<String>.generate(
                          barcodeScanRes.length,
                          (index) => barcodeScanRes[index]);
                      setState(() {
                        if (barcodeScanRes[barcodeScanRes.length - 3] == '-') {
                          searchKeywords.removeLast();
                          barcodeScanRes = searchKeywords.join("");

                          // print('${barcodeScanRes} ${now}');
                        } else {
                          final now = DateTime.now();
                          barcodeScanRes = searchKeywords.join("");

                          // print('${barcodeScanRes} ${now}');
                        }
                        barcodeScanRes = barcodeScanRes;
                        _personas.add(Persona('Rut: ${barcodeScanRes} ',
                            'Ubicación: ${ubicacion}', 'Fecha: ${now}'));
                      });
                    });
                  }

                  scanQr();
                  // Validar si el rut no tiene digitos extras
                },
              ),
            ],
          ),
          body: ListView.builder(
              itemCount: _personas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Mapa()));
                  },
                  title: Text(
                      _personas[index].rut + ' ' + _personas[index].fechaHora),
                  subtitle: Text(_personas[index].ubicacion),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              })),
    );
  }
}

class Persona {
  String rut = "";
  String ubicacion = "";
  String fechaHora = "";

  Persona(rut, ubicacion, fechaHora) {
    this.rut = rut;
    this.ubicacion = ubicacion;
    this.fechaHora = fechaHora;
  }
}

Future<String> getLocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {}
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {}
  }
  _locationData = await location.getLocation();

  return _locationData.altitude.toString();
}
