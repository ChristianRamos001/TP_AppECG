//import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:polar/polar.dart';
import 'package:intl/intl.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/repository_ecg.dart';
import 'dart:math';

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

  void sentToCloud() async{
    print('ECG data FINAL: ${_joinedECGdata.length}');
    DateTime currentDatetime = DateTime.now();
    Random random = Random();
    int randomNumber = random.nextInt(2);
    List<String> listNumber = ['11','12','16'];

      _sendECGModel = SendECG(listNumber[randomNumber], _joinedECGdata, DateTime.now());
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
                      child: Text("Captura de Datos del Electrocardiograma")),
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
