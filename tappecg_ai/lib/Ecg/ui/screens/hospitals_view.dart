import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/map_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/navbar.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class hospital {
  final String nombreCS;
  final String direccion;
  final String telefono;
  final double latitud;
  final double longitud;
  final String urlPhoto;

  const hospital({
    required this.nombreCS,
    required this.direccion,
    required this.telefono,
    required this.latitud,
    required this.longitud,
    required this.urlPhoto,
  });

  factory hospital.fromJson(Map<String, dynamic> json) {
    return hospital(
      nombreCS: json['nombreCS'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      urlPhoto: json['urlPhoto'],
    );
  }
}

Future<hospital> getHospital() async {
  var url =
      "https://app-api-ai-heart-mt-prod-eu2-01.azurewebsites.net/api/CentrosSalud/Visualizar";

  final response = await http.get(Uri.parse(url));

  return hospital.fromJson(jsonDecode(response.body));
}

class Hospital extends StatefulWidget {
  const Hospital({Key? key}) : super(key: key);

  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  late Future<hospital> centro;

  Completer<GoogleMapController> controller = Completer();

  static const CameraPosition cameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  @override
  void initState() {
    super.initState();
    centro = getHospital();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        drawer: NavBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                  child: const Center(
                child: Text(
                  "Centro de Salud",
                  style: TextStyle(fontSize: 25, color: Colors.green),
                ),
              )),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
                child: Center(
                    child: FutureBuilder<hospital>(
              future: centro,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.network(
                    snapshot.data!.urlPhoto,
                    width: 300,
                    height: 300,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ))),
            const SizedBox(
              height: 25,
            ),
            Container(
                child: Center(
                    child: FutureBuilder<hospital>(
              future: centro,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.nombreCS,
                    style: const TextStyle(fontSize: 15, color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ))),
            const SizedBox(
              height: 25,
            ),
            Container(
                child: Center(
                    child: FutureBuilder<hospital>(
              future: centro,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.telefono,
                    style: const TextStyle(fontSize: 15, color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ))),
            const SizedBox(
              height: 25,
            ),
            Container(
                child: Center(
                    child: FutureBuilder<hospital>(
              future: centro,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.direccion,
                    style: const TextStyle(fontSize: 15, color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ))),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder<hospital>(
              future: centro,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => MapView(
                                    snapshot.data!.latitud,
                                    snapshot.data!.longitud)));
                      },
                      child: const Center(
                        child: Text("Ver en Maps"),
                      ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            )
          ]),
        ));
  }
}
