
import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'dart:convert';
import 'event_hub_api.dart';
import "package:http/http.dart" as http;

class RecordecgsRepository{
  RecordecgsRepository(){}
  final String url = "https://app-api-ai-heart-mt-prod-eu2-01.azurewebsites.net/api/";
                      
  Future<List<Recordecgs>> getRecordecgs() async {

    final response = await http.get(
    Uri.parse(url + "recordecgs/mobile"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + UserHelper.token
    }
    );
    var items = json.decode(response.body);
    var recordecgs = await items.map((item) => Recordecgs.fromMap(item)).toList().cast<Recordecgs>();

    return recordecgs;
  }
}