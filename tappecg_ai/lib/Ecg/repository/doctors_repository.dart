
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'dart:convert';
import '../model/doctor.dart';
import 'event_hub_api.dart';
import "package:http/http.dart" as http;

class DoctorsRepository{
  DoctorsRepository(){}
  final String url = "https://app-api-ai-heart-mt-prod-eu2-01.azurewebsites.net/api/";

  Future<List<Doctor>> getDoctors() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aux = await prefs.getString('token')?? "";
    final response = await http.get(
        Uri.parse(url + "Pacientes/mobile/VizualizeDoctors"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + aux
        }
    );
    var items = json.decode(response.body);
    var doctors = await items.map((item) => Doctor.fromMap(item)).toList().cast<Doctor>();

    return doctors;
  }
}