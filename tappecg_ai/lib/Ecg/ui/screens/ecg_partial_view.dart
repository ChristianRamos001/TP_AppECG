//import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:polar/polar.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/repository_ecg.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:isolate_handler/isolate_handler.dart';

class EcgPartialView extends StatefulWidget {
  const EcgPartialView({Key? key}) : super(key: key);

  @override
  _EcgPartialView createState() => _EcgPartialView();
}

class _EcgPartialView extends State<EcgPartialView> {
  static void loop(Map<String, dynamic> context) {
    final messenger = HandledIsolate.initialize(context);
    messenger.listen((count) {
      messenger.send(++count);
    });
  }

  final isolate = IsolateHandler();
  int counter = 0;
  void _onPressed() async {
    isolate.spawn<int>(loop,
        name: "counter",
        onReceive: setCounter,
        onInitialized: () => isolate.send(counter, to: "counter"));
    //await compute(loop, 1);
  }

  void setCounter(int count) {
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 0);
    if (zonedTime.hour == 18) {
      print("holaaaaaaaaaaaaaaaaaaajejejee**********************************");
      startECG();
    }
    counter = count;
    isolate.kill;
  }

  static final _limitCount = 100;
  static final _points = <FlSpot>[];
  static double _xValue = 0;
  static final double _step = 0.03;
  static bool _firstTime = true;
  static final Color _colorLine = Colors.redAccent;

  static Polar polar = Polar();

  static const identifier = '7E1B542A';
  static String _textState =
      "Active el Bluetooth y colóquese el dispositivo en el pecho para empezar por favor";
  static bool _startECG = false;
  static late SendECG _sendECGModel;
  static RepositoryECG respositoryECG = RepositoryECG();

  static final List<int> _joinedECGdata = <int>[];

  static void startECG() {
    polar.deviceConnectingStream.listen((_) => _textState = "Conectando");

    polar.deviceConnectedStream.listen((_) => _textState = "Conectado!");

    var currentTimestamp = 0;

    polar.streamingFeaturesReadyStream.listen((e) {
      print("1111111111111111111111111111111111111111111111111111");
      if (e.features.contains(DeviceStreamingFeature.ecg)) {
        print("2222222222222222222222222222222222222222222222");
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

          print('ECG data: ${e.samples}');
          _joinedECGdata.addAll(e.samples);
        });
      }
    });

    polar.deviceDisconnectedStream.listen((_) {
      print("aboutTOSEND********************************");
      sentToCloud();
      _textState = "Prueba completada";
    });

    polar.connectToDevice(identifier);
    _startECG = true;
  }

  static void sentToCloud() async {
    print('ECG data FINAL: ${_joinedECGdata.length}');
    DateTime currentDatetime = DateTime.now();

    _sendECGModel = SendECG("12", _joinedECGdata, DateTime.now());
    var response = await respositoryECG.postECGData(_sendECGModel);
    //bool correct = true;
    print(response.toString());
  }

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
    //startECG();
  }

  @override
  Widget build(BuildContext context) {
    return !_startECG
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      child: const Text(
                          "Captura de Datos del Electrocardiograma")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("1. Permanecer en Reposo"),
                      Text("2. No mover el dispositivo durante la prueba"),
                      Text(
                          "3. Los datos proporcionados serán enviados en su Centro de Salud"),
                      Text("4. Los resultados serán visibles en el Hospital")
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
                      onPressed: () => _onPressed(),
                      child: const Text(
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
