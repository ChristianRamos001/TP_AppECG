import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:isolate_handler/isolate_handler.dart';
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

  void onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

//------
  @override
  void initState() {
    super.initState();
    print("INIT******************************+");
    _onPressed();
  }

//------
  static void loop(Map<String, dynamic> context) {
    final messenger = HandledIsolate.initialize(context);
    messenger.listen((count) {
      messenger.send(++count);
    });

    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 0);
    if (zonedTime.hour == 18) {
      print("holaaaaaaaaaaaaaaaaaaajejejee**********************************");
      startECG();
    }
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
    counter = count;
    isolate.kill;
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

          //print('ECG TIME: ${e.timeStamp}');
          if ((e.timeStamp - currentTimestamp) / 1000000000 >= 30) {
            // 1 minuto/ 30 segundos
            polar.disconnectFromDevice(identifier);
          }

          //print('ECG data: ${e.samples}');
          _joinedECGdata.addAll(e.samples);
        });
      }
    });

    polar.deviceDisconnectedStream.listen((_) {
      //print("aboutTOSEND********************************");
      sentToCloud();
    });

    polar.connectToDevice(identifier);
  }

  static void sentToCloud() async {
    //print('ECG data FINAL: ${_joinedECGdata.length}');
    //DateTime currentDatetime = DateTime.now();

    _sendECGModel = SendECG("12", _joinedECGdata, DateTime.now());
    var response = await respositoryECG.postECGData(_sendECGModel);
    //bool correct = true;
    //print(response.toString());
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
