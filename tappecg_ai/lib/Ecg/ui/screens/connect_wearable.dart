import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_blue/gen/flutterblue.pb.dart';

class Connect_wearable extends StatefulWidget {
  const Connect_wearable({Key? key}) : super(key: key);

  @override
  _Connect_wearableState createState() => _Connect_wearableState();
}

class _Connect_wearableState extends State<Connect_wearable> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  late var device;
  late String status = "";
  late List<Object> devices = [];

  @override
  void initState() {
    super.initState();
  }

  void setDevice(var device) {
    setState(() {
      status = "Seleccionado: " + device.name;
    });

    this.device = device;
  }

  Future<List<Object>> getList() async {
    return devices;
  }

  void scanDevices() async {
    flutterBlue.startScan(timeout: Duration(seconds: 2));

    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}***********************');
        setState(() {
          if (r.device.name != "") devices.add(r.device);
        });
      }
    });
    flutterBlue.stopScan();
  }

  void connectToDevice() async {
    await device.connect();
    setState(() {
      status = "Conectado: " + device.name;
    });
  }

  void selectDevice() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Buscar dispositivos Polar"),
              ],
            ),
          ),
          Container(
            child: FutureBuilder(
                future: getList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: devices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data[index].name),
                        onTap: () => setDevice(snapshot.data[index]),
                      );
                    },
                  );
                }),
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
                onPressed: () => setState(() {
                  scanDevices();
                }),
                child: Text(
                  "Buscar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
                onPressed: () => connectToDevice(),
                child: Text(
                  "Conectar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Text(status),
        ],
      ),
    );
  }
}
