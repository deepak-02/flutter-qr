import 'dart:async';

import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var qrData = "this is a qr";
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    startTimer();
    getQr();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      fetchDataFromAPI();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          child: CustomPaint(
            // painter: Painter(),
            painter: QrPainter(
                data: qrData,
                options: const QrOptions(
                    shapes: QrShapes(
                        darkPixel: QrPixelShapeRoundCorners(cornerFraction: .5),
                        frame:  QrFrameShapeRoundCorners(cornerFraction: .25),
                        ball: QrBallShapeRoundCorners(cornerFraction: .25)
                    ),
                    colors: QrColors(
                        dark: QrColorLinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 0, 0),
                              Color.fromARGB(255, 0, 0, 255)
                            ],
                            orientation: GradientOrientation.leftDiagonal
                        )
                    )
                )),
            size: const Size(350, 350),
          ),
        ),
      ),
    );
  }

  void getQr() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.4:8080/api/rest/qr-generator'),
    );

    print(response.body);

    setState(() {
      qrData = response.body;
    });

  }

  void fetchDataFromAPI() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.4:8080/api/rest/response'),
    );
    print('response:');
    print(response.body);

    if(response.body == 100 || response.body == '100'){
      getQr();
    }
  }
}