import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/model/doctor.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../repository/doctors_repository.dart';
import 'navbar.dart';

class DoctorView extends StatefulWidget {
  const DoctorView({Key? key}) : super(key: key);

  @override
  _DoctorViewState createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  final doctorsRepository = DoctorsRepository();
  List<Doctor> doctors = [];

  Future<void> makeRequest() async {
    var items = doctors = await doctorsRepository.getDoctors();
    setState(() {
      doctors = items;
    });
  }

  initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        drawer: NavBar(),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: doctors == null ? 0 : doctors.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                              Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 70),
                                      child: Container(
                                          color: Colors.black,
                                          child: Image.network(
                                            "https://dhb3yazwboecu.cloudfront.net/270/fabercastell/colores/155_m.jpg",
                                            width: double.infinity,
                                            height: 140,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Positioned(
                                      top: 70,
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.grey.shade800,
                                        backgroundImage:
                                            NetworkImage(doctors[i].urlIcon),
                                      ),
                                    )
                                  ]),
                              Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Text(doctors[i].nombre +" "+ doctors[i].apellidoP +" " + doctors[i].apellidoM, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,)
                                  ),

                                ],
                              )
                            ]),
                          ),
                        ),
                      );
                    }))
          ],
        ));
  }
}
