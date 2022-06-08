import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/ecg_partial_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/list_results_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/send_ecg.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:polar/polar.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/repository_ecg.dart';
import 'dart:async';
import '../constants.dart';
import 'custom_animated_bottom_bar.dart';

void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;
  bool _firstTime = true;
  static const identifier = '7E1B542A';

  bool intro = true;
  late SendECG _sendECGModel;
  RepositoryECG respositoryECG = RepositoryECG();

  List<int> _joinedECGdata = <int>[];

  void startECG() {
    Polar polar = Polar();
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
    });

    polar.connectToDevice(identifier);
  }

  void sentToCloud() async {
    print('ECG data FINAL: ${_joinedECGdata.length}');
    DateTime currentDatetime = DateTime.now();

    _sendECGModel = SendECG("12", _joinedECGdata, DateTime.now());
    var response = await respositoryECG.postECGData(_sendECGModel);
    //bool correct = true;
    print(response.toString());
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    _firstTime = true;
    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
    print("INICIO ALGO");
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
        notificationTitle: 'Servicio de electrocardiograma automático',
        notificationText: 'eventCount: $_eventCount');

    // Send data to the main isolate.
    sendPort?.send(_eventCount);
    //startECG();
    _eventCount++;
    print("Sera?");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

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
    //_initForegroundTask();
    //_ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
    // You can get the previous ReceivePort without restarting the service.
    //  if (await FlutterForegroundTask.isRunningService) {
    //   final newReceivePort = await FlutterForegroundTask.receivePort;
    //   _registerReceivePort(newReceivePort);
    //}
    //});
    //_startForegroundTask();
  }

//*************************************************************************** */
  ReceivePort? _receivePort;

  Future<void> _initForegroundTask() async {
    print("inittuputamadrefoeground");
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'notification_channel_id',
          channelName: 'Foreground Notification',
          channelDescription:
              'This notification appears when the foreground service is running.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          iconData: const NotificationIconData(
            resType: ResourceType.mipmap,
            resPrefix: ResourcePrefix.ic,
            name: 'launcher',
            backgroundColor: Colors.orange,
          )),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 18000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

  Future<bool> _startForegroundTask() async {
    print("_startforegroundtask*************");
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    ReceivePort? receivePort;
    if (await FlutterForegroundTask.isRunningService) {
      receivePort = await FlutterForegroundTask.restartService();
    } else {
      print("jujujujujujujuyatamos");
      receivePort = await FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }

    return _registerReceivePort(receivePort);
  }

  Future<bool> _stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? receivePort) {
    print("registernosequechchuareceiveport");
    _closeReceivePort();

    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen((message) {
        if (message is int) {
          print('eventCount: $message');
        } else if (message is String) {
          if (message == 'onNotificationPressed') {
            Navigator.of(context).pushNamed('/resume-route');
          }
        } else if (message is DateTime) {
          print('timestamp: ${message.toString()}');
        }
      });

      return true;
    }

    return false;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  T? _ambiguate<T>(T? value) => value;

  @override
  void dispose() {
    _closeReceivePort();
    super.dispose();
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
