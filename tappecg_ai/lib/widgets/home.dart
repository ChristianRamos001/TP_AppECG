import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/ecg_partial_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/list_results_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/send_ecg.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:polar/polar.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/repository_ecg.dart';
import 'dart:math';

import '../constants.dart';
import 'custom_animated_bottom_bar.dart';

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
    const EcgPartialView(),
    SendEcg(),
    SendEcg(),
  ];

//------

  static void loop(int val) {
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 0);
    if (zonedTime.hour == 18) {
      print("holaaaaaaaaaaaaaaaaaaajejejee**********************************");
      startECG();
    }
  }

  void _onPressed() async {
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
  }

//*************************************************************************** */

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
    print("inside STARTECG***********************************");
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
          _joinedECGdata.addAll(e.samples); //THIS WAS IN A SETSTATE
        });
      }
    });

    polar.deviceDisconnectedStream.listen((_) {
      sentToCloud();
    });

    polar.connectToDevice(identifier);
  }

  static void sentToCloud() async {
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

  static LineChartBarData line() {
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

//------

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
          icon: const Icon(Icons.assignment),
          title: const Text('Registros'),
          activeColor: colorIcon,
          inactiveColor: darkPrimaryColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.query_stats),
          title: const Text('Análisis ECG'),
          activeColor: colorIcon,
          inactiveColor: darkPrimaryColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.message),
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
