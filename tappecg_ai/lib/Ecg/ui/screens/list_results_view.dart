import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tappecg_ai/Ecg/model/dates_abnormalities.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/recordecgs.dart';
import 'package:tappecg_ai/Ecg/ui/screens/ecg_detail.dart';
import 'package:tappecg_ai/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:polar/polar.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/repository_ecg.dart';

class ListResults extends StatefulWidget {
  @override
  ListResultsState createState() => ListResultsState();
}

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
    startECG();
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
    startECG();
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

class ListResultsState extends State<ListResults> {
  bool _value = false;

  Map<DateTime, List<Event>>? selectedEvents;
  CalendarFormat format = CalendarFormat.twoWeeks;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  final recordecgsRepository = RecordecgsRepository();
  var isLoading = true;
  var isempty = false;
  List<Recordecgs> recordecgs = [];
  List<DatesAbnormalities> datesAbnormalities = [];

  initState() {
    selectedEvents = {};
    this.getDatesAbnormalities();
    this.makeRequest();
    super.initState();
  }

  Future<void> makeRequest() async {
    var items = recordecgs = await recordecgsRepository.getRecordecgs();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();
    print(statuses[Permission.location]);

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }

    setState(() {
      isLoading = !isLoading;
      recordecgs = items;
      print(items.length);
      if (items.length < 1) {
        isempty = true;
      } else {
        isempty = false;
      }
    });
  }

  Future<void> getDatesAbnormalities() async {
    var items2 =
        datesAbnormalities = await recordecgsRepository.getDatesAbnormalities();

    setState(() {
      datesAbnormalities = items2;
      datesAbnormalities.forEach((element) {
        if (selectedEvents![
                DateFormat("yyyy-MM-dd").format(element.dateResult)] !=
            null) {
          selectedEvents![DateFormat("yyyy-MM-dd").format(element.dateResult)]
              ?.add(
            Event(title: _eventController.text),
          );
        } else {
          selectedEvents![element.dateResult] = [
            Event(title: element.isAbnormal.toString())
          ];
        }
      });
    });
  }

  List<Event> _getEventsfromDay(DateTime date) {
    var item = DateFormat("yyyy-MM-dd").format(date);
    return selectedEvents![DateTime.parse(item)] ?? [];
  }

  Future<void> makeRequestDate(DateTime date) async {
    var items = recordecgs = await recordecgsRepository.getRecordecgsDate(date);
    setState(() {
      isLoading = false;
      recordecgs = items;
      print(items.length);
      if (items.length < 1) {
        isempty = true;
      } else {
        isempty = false;
      }
    });
  }

  var _showCalendar = false;

  void showCalendar() {
    setState(() {
      selectedDay = DateTime.now();
      focusedDay = DateTime.now();
      makeRequest();
      setState(() {
        isLoading = !isLoading;
      });
      _showCalendar = !_showCalendar;
    });
  }

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
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.maybeOf(context)!.size;

    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 5, 24, 0),
          child: Row(children: <Widget>[
            Expanded(
              child: Text(
                "Historial",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25, color: darkPrimaryColor),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_month_rounded,
                color: darkPrimaryColor,
              ),
              onPressed: () {
                showCalendar();
              },
            ),
            Switch.adaptive(
              value: _value,
              onChanged: (newValue) => setState(() {
                _value = newValue;
                if (_value) {
                  print("Valor verdadero");
                  _initForegroundTask();
                  _ambiguate(WidgetsBinding.instance)
                      ?.addPostFrameCallback((_) async {
                    // You can get the previous ReceivePort without restarting the service.
                    if (await FlutterForegroundTask.isRunningService) {
                      final newReceivePort =
                          await FlutterForegroundTask.receivePort;
                      _registerReceivePort(newReceivePort);
                    }
                  });
                  _startForegroundTask();
                }
                if (!_value) {
                  print("Valor falso");
                  _stopForegroundTask();
                }
              }),
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ]),
        ),
        _showCalendar
            ? TableCalendar(
                locale: 'es',
                focusedDay: selectedDay,
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                calendarFormat: format,
                onFormatChanged: (CalendarFormat _format) {
                  setState(() {
                    format = _format;
                  });
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekVisible: true,

                //Day Changed
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState(() {
                    isLoading = true;
                    makeRequestDate(focusDay);
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                },
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },
                eventLoader: (day) {
                  //print(_getEventsfromDay(day));
                  return _getEventsfromDay(day);
                },

                //To style the Calendar
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : SizedBox(
                height: 0,
              ),
        SizedBox(
          height: 2,
        ),
        isLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              )
            : !isempty
                ? Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(16, 5, 16, 16),
                        itemCount: recordecgs == null ? 0 : recordecgs.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Center(
                              child: GestureDetector(
                            child: Card(
                                child: InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SfCartesianChart(
                                                borderColor: Color(0xFF00BCD4),
                                                borderWidth: 2,
                                                margin: EdgeInsets.all(15),
                                                palette: <Color>[
                                                  Color(0xFF4881B9)
                                                ],
                                                series: <ChartSeries>[
                                                  LineSeries<double, double>(
                                                      dataSource: recordecgs[i]
                                                          .data[0]
                                                          .dataECG,
                                                      xValueMapper:
                                                          (double item, _) =>
                                                              _.toDouble(),
                                                      yValueMapper:
                                                          (double item, _) =>
                                                              item)
                                                ],
                                              ),
                                              ListTile(
                                                title: Text(
                                                  recordecgs[i].labelResult,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: recordecgs[i]
                                                                  .labelResult ==
                                                              "Resultados Anormales"
                                                          ? Color(0xffD9124B)
                                                          : Color.fromRGBO(
                                                              208, 218, 40, 1)),
                                                ),
                                                subtitle: Text(
                                                  recordecgs[i].subLabel +
                                                      "\n" +
                                                      DateFormat("yyyy-MM-dd")
                                                          .format(recordecgs[i]
                                                              .readDate),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.grey),
                                                ),
                                                trailing: GestureDetector(
                                                  onTap: () =>
                                                      goDetails(recordecgs[i]),
                                                  child: Container(
                                                    height: 40,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF4881B9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                      child: Text(
                                                        'Abrir',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ])))),
                          ));
                        }))
                : Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            child: FittedBox(
                                child: Image(
                                  image: AssetImage("assets/ECG_NULLv2.png"),
                                ),
                                fit: BoxFit.fill),
                          ),
                          Text(
                            'No existen registros analizados en este día',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  )
      ]),
    );
  }

  void goDetails(Recordecgs ecg) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => Ecg_detail(ecg: ecg)));
  }
}

class Event {
  final String title;
  Event({required this.title});

  String toString() => this.title;
}
