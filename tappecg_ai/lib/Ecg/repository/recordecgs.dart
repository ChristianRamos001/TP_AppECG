import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'dart:convert';
import '../model/dates_abnormalities.dart';
import 'event_hub_api.dart';
import "package:http/http.dart" as http;

class RecordecgsRepository {
  RecordecgsRepository() {}
  final String url =
      "https://app-api-ai-heart-mt-prod-eu2-01.azurewebsites.net/api/";

  Future<List<Recordecgs>> getRecordecgs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aux = await prefs.getString('token') ?? "";
    final response =
        await http.get(Uri.parse(url + "recordecgs/mobile"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + aux
    });
    var items = json.decode(response.body);
    var recordecgs = await items
        .map((item) => Recordecgs.fromMap(item))
        .toList()
        .cast<Recordecgs>();
    String? aux1 = await prefs.getString('email');
    String? aux2 = await prefs.getString('name');
    UserHelper.email = await aux1;
    UserHelper.name = await aux2;
    return recordecgs;
  }

  Future<List<Recordecgs>> getRecordecgsDate(DateTime date) async {

    print(DateFormat("yyyy-MM-dd").format(date));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aux = await prefs.getString('token') ?? "";
    print("hace consutla");
    try {
      final response = await http.post(
        Uri.parse(url + "RecordEcgs/mobile/FilterDayECGMobile"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + aux
        },
        body: jsonEncode({"dateFilter": DateFormat("yyyy-MM-dd").format(date)}),
      );
      var items = json.decode(response.body);
      var recordecgs = await items
          .map((item) => Recordecgs.fromMap(item))
          .toList()
          .cast<Recordecgs>();
      return recordecgs;
    } catch (e) {
      return [];
    }
  }

  Future<List<DatesAbnormalities>> getDatesAbnormalities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aux = await prefs.getString('token') ?? "";
    final response =
    await http.get(Uri.parse(url + "/RecordEcgs/mobile/datesAbnormalities"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + aux
    });
    var items = json.decode(response.body);
    var datesAbnormalities = await items
        .map((item) => DatesAbnormalities.fromMap(item))
        .toList()
        .cast<DatesAbnormalities>();

    return datesAbnormalities;
  }

  Future<Recordecg> getRecordecg(recordId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aux = await prefs.getString('token') ?? "";
    final response =
    await http.get(Uri.parse(url + "RecordECGs/mobile/"+ recordId.toString()), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + aux
    });
    var items = json.decode(response.body);
    var recordecgs = await Recordecg.fromMap(items);
    return recordecgs;
  }
}
