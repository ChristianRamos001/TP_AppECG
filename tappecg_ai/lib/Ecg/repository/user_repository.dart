
import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/model/send_ecg.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'dart:convert';
import 'event_hub_api.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
class UserRepository{
  UserRepository(){}
  final String url = "https://app-api-ai-heart-mt-prod-eu2-01.azurewebsites.net/api/";

  Future<void>saveToken(token, email, name) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('email', email);
      await prefs.setString('name', name);
  }

  Future<String> loginRequest(String email, String password) async {

    try{
      final response = await http.post(
      Uri.parse(url + "usuarios/loginapp"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({"email": email, "password": password}),
    );



    if(response.statusCode == 200){
      var extractData =  json.decode(response.body);
      UserHelper.token =  extractData["token"];
      UserHelper.email = email;
      UserHelper.id = extractData["idusuario"];
      UserHelper.name = extractData["nombre"];
      saveToken(extractData["token"],email,UserHelper.name);
      //return extractData["token"];
      return  'success';
    }else {
      return 'failed';
    }
    }catch(e){
      return e.toString();
    }
  }
}