//import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:polar/polar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/repository_ecg.dart';
import 'dart:math';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:tappecg_ai/constants.dart';

import '../../model/user.dart';

class EcgPartialView extends StatefulWidget {
  EcgPartialView({Key? key}) : super(key: key);

  @override
  _EcgPartialView createState() => _EcgPartialView();
}

class _EcgPartialView extends State<EcgPartialView> {
  final _limitCount = 100;
  final _points = <FlSpot>[];
  double _xValue = 0;
  double _step = 0.03;
  bool _firstTime = true;
  final Color _colorLine = Colors.redAccent;

  Polar polar = Polar();

  static const identifier = '7E1B542A';
  String _textState =
      "Active el Bluetooth y colóquese el dispositivo en el pecho para empezar por favor";
  bool _startECG = false;
  bool intro = true;
  late SendECG _sendECGModel;
  RepositoryECG respositoryECG = RepositoryECG();

  List<int> _joinedECGdata = <int>[];

  void startECG() {
    polar.deviceConnectingStream.listen((_) => setState(() {
          _textState = "Conectando";
        }));

    polar.deviceConnectedStream.listen((_) => setState(() {
          _textState = "Conectado!";
        }));

    var currentTimestamp = 0;

    polar.streamingFeaturesReadyStream.listen((e) {
      if (e.features.contains(DeviceStreamingFeature.ecg)) {
        polar.startEcgStreaming(e.identifier).listen((e) {
          if (_firstTime) {
            currentTimestamp = e.timeStamp;
            _firstTime = false;
          }

          while (_points.length > _limitCount) {
            _points.removeAt(0);
          }

          //
          for (var i = 0; i < e.samples.length; i++) {
            _points.add(FlSpot(_xValue, e.samples[i] / 1000.0));
            _xValue += _step;
          }
          print('ECG TIME: ${e.timeStamp}');
          if ((e.timeStamp - currentTimestamp) / 1000000000 >= 30) {
            // 1 minuto/ 30 segundos
            polar.disconnectFromDevice(identifier);
          }

          setState(() {
            print('ECG data: ${e.samples}');
            _joinedECGdata.addAll(e.samples);
          });

        });
      }
    });

    polar.deviceDisconnectedStream.listen((_) {
      sentToCloud();
      setState(() {
        _textState = "Prueba completada";
      });
    });

    polar.connectToDevice(identifier);
    setState(() {
      _startECG = true;
    });
  }

  void sentToCloud() async {
    print('ECG data FINAL: ${_joinedECGdata.length}');
    DateTime currentDatetime = DateTime.now();

      _sendECGModel = SendECG("12", _joinedECGdata, DateTime.now());
      var response = await respositoryECG.postECGData(_sendECGModel);
      //bool correct = true;
      print(response.toString());
  }
  List<Slide> slides = [];

  LineChartBarData line() {
    return LineChartBarData(
      spots: _points,
      dotData: FlDotData(
        show: false,
      ),
      colors: [_colorLine.withOpacity(0), _colorLine],
      colorStops: [0.1, 1.0],
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  void initState() {
    super.initState();
    slides.add(
      Slide(
        title: "Reposo",
        description:
            "1. Permanecer en Reposo, de preferencia en un lugar cómodo",
        pathImage: "assets/logo.png",
        backgroundColor: const Color(0xffecfbf3),
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
    slides.add(
      Slide(
        title: "Posicionamiento de la Banda",
        description: "2. Ubicar la Banda como se muestra en la figura",
        pathImage: "assets/logo.png",
        backgroundColor: const Color(0xffecfbf3),
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
    slides.add(
      Slide(
        title: "No mover la Banda Inteligente",
        description:
            "3. No mover la banda inteligente durante el transcurso de la prueba",
        pathImage: "assets/logo.png",
        backgroundColor: const Color(0xffecfbf3),
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
    slides.add(
      Slide(
        title: "Envío de Datos al Hospital",
        description:
            "4. Los datos recopilados serán enviados a su Médico desigando",
        pathImage: "assets/logo.png",
        backgroundColor: const Color(0xffecfbf3),
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
    slides.add(
      Slide(
        title: "Visualización en el Historial",
        description: "5. Los ECG's realizados se podrán ver en el Historial",
        pathImage: "assets/logo.png",
        backgroundColor: const Color(0xffecfbf3),
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
    //startECG();
  }

  Future<void> introviewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introviewed', true);
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color:  Colors.white,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return const Text("Saltar",
        style: TextStyle( color: Colors.white));
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(primaryColor),
      overlayColor: MaterialStateProperty.all<Color>(accent),
    );
  }

  void onDonePress() {
    introviewed().whenComplete(() {
      setState(() {
        intro = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return intro
        ? IntroSlider(
            // Skip button
            renderSkipBtn: renderSkipBtn(),
            skipButtonStyle: myButtonStyle(),

            // Next button
            renderNextBtn: renderNextBtn(),
            nextButtonStyle: myButtonStyle(),

            // Done button
            renderDoneBtn: renderDoneBtn(),
            onDonePress: onDonePress,
            doneButtonStyle: myButtonStyle(),

            // Dot indicator
            colorDot: darkPrimaryColor,
            sizeDot: 13.0,

            slides: slides,
          )
        : !_startECG
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          child:
                              Text("Captura de Datos del Electrocardiograma")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1. Permanecer en Reposo"),
                          Text("2. No mover el dispositivo durante la prueba"),
                          Text(
                              "3. Los datos proporcionados serán enviados en su Centro de Salud"),
                          Text(
                              "4. Los resultados serán visibles en el Hospital")
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(2.0)),
                        child: TextButton(
                          onPressed: () => startECG(),
                          child: Text(
                            "Empezar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _textState,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _points.isNotEmpty
                        ? SizedBox(
                            height: 400,
                            child: LineChart(
                              LineChartData(
                                minY: -1.5,
                                maxY: 1.5,
                                minX: _points.first.x,
                                maxX: _points.last.x,
                                lineTouchData: LineTouchData(enabled: false),
                                clipData: FlClipData.all(),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                ),
                                lineBarsData: [
                                  line(),
                                ],
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              );
  }

  @override
  void dispose() {
    polar.disconnectFromDevice(identifier);
    super.dispose();
  }
}
