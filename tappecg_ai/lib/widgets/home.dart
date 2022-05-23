import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/list_results_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/navbar.dart';
import 'package:tappecg_ai/Ecg/ui/screens/send_ecg.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';

import '../Ecg/ui/screens/ecg_partial_view.dart';
import '../constants.dart';
import 'custom_animated_bottom_bar.dart';

import 'package:tappecg_ai/Ecg/services/notification_registration_service.dart';
import 'package:tappecg_ai/config.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home();
  }
}

class _Home extends State<Home> {
  final notificationRegistrationService = NotificationRegistrationService(
      Config.backendServiceEndpoint, Config.apiKey);

  void registerButtonClicked() async {
    try {
      await notificationRegistrationService
          .registerDevice(List<String>.empty());
    } catch (e) {
      print(e);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        drawer: NavBar(),
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
