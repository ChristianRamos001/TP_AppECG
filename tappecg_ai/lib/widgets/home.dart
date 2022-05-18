import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/ecg_partial_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/list_results_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/send_ecg.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:tappecg_ai/local_notification.dart';

import '../constants.dart';
import 'custom_animated_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:tappecg_ai/Ecg/ui/screens/ecg_partial_view.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:polar/polar.dart';
import 'package:intl/intl.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/repository_ecg.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home();
  }
}

class _Home extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> widgetsChildren = [
    ListResults(),
    EcgPartialView(),
    SendEcg(),
    SendEcg(),
  ];

  late int _counter;

  void loop(int val) {
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 0);
    if (zonedTime.hour == 18 && zonedTime.minute == 0) {
      print("holaaaaaaaaaaaaaaaaaaa**********************************");
      //startECG();
    }
  }

  void request(int val) {
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 0);
    if (zonedTime.hour == 18 && zonedTime.minute == 0) {
      print("peticion**********************************");
    }
  }

  Future<void> _onPressed() async {
    await compute(loop, 1);
  }

  void onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _onPressed();
    tz.initializeTimeZones();
    NotificationService().showNotification(1, "title", "body", 10);
  }

//*************************************************************************** */

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

  void sentToCloud() async {
    print('ECG data FINAL: ${_joinedECGdata.length}');
    DateTime currentDatetime = DateTime.now();
    Random random = Random();
    int randomNumber = random.nextInt(2);
    List<String> listNumber = ['11', '12', '16'];

    _sendECGModel =
        SendECG(listNumber[randomNumber], _joinedECGdata, DateTime.now());
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        body: widgetsChildren[_currentIndex],
        bottomNavigationBar: _buildBottomBar());
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 75,
      backgroundColor: primaryColor,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 25,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.assignment),
          title: Text('Registros'),
          activeColor: colorIcon,
          inactiveColor: darkPrimaryColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.query_stats),
          title: Text('Análisis ECG'),
          activeColor: colorIcon,
          inactiveColor: darkPrimaryColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.message),
          title: const Text(
            "Preguntas",
          ),
          activeColor: colorIcon,
          inactiveColor: darkPrimaryColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.watch),
          title: const Text('Dispositivo'),
          activeColor: colorIcon,
          inactiveColor: darkPrimaryColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      Container(
        alignment: Alignment.center,
        child: const Text(
          "1",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "2",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "3",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "4",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}
