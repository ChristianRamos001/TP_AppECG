import 'dart:convert';
//import 'dart:io';

import "package:http/http.dart" as http;
import "package:tappecg_ai/Ecg/model/send_ecg.dart";

class EventHubAPI {
  final String sasURL =
      "https://app-api-ai-heart-mt-prod-eu2-01.azurewebsites.net/api/WeatherForecast/TokenSAS";
  final String serviceNamespace = "evh-ia-heart-mt-eu2-prod-01";
  final String hubName = 'ecg-data-user-mobile';

  String urlService = "";
  String host = "";

  //Future<StorageUploadTask> uploadFile(String path, File image) async{
  // return _storageReference.child(path).putFile(image);
  //}
  EventHubAPI() {
    urlService = 'https://$serviceNamespace.servicebus.windows.net/$hubName';
    host = '$serviceNamespace.servicebus.windows.net';
  }

  Future<String> postECGData(SendECG modelSendECG) async {
    // BODY
    // {
    //   "user": "1",
    //   "listDataECG": [1,2,3,4,4,4,4]
    // }

    String token = await tokenSAS();
    var uri = Uri.parse("https://evh-ia-heart-mt-eu2-prod-01.servicebus.windows.net/ecg-data-user-mobile/messages");

    if (token != "") {

      final response = await http.post(
        uri,
          headers: <String, String>{
            'Content-Type': 'application/atom+xml;type=entry;charset=utf-8',
            'Authorization': token,
          },
        body: jsonEncode(modelSendECG.toJson()),
      );
      //'listDataECG': modelSendECG.listDataECG.toString(),
      //'user':modelSendECG.user

      if (response.statusCode == 201) {
        return response.statusCode.toString();
      } else {
        return response.statusCode.toString();
      }
    } else {
      return "Estado nada";
    }
  }

  Future<String> tokenSAS() async {
    var uri = Uri.parse(sasURL);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      String sasToken = responseData['sasToken'];
      print('TOKEN: $sasToken');
      return sasToken;
    } else {
      return "";
    }
  }

  void sentTo() async {
    // Read the service account credentials from the file.
    /*var jsonCredentials =
    await rootBundle.loadString('assets/jsoncredentials_dev_pub.json');
    ;
    var credentials =
    new auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    // Get an HTTP authenticated client using the service account credentials.
    var client = await auth.clientViaServiceAccount(credentials, PubSub.SCOPES);

    // Instantiate objects to access Cloud Datastore, Cloud Storage
    // and Cloud Pub/Sub APIs.
    var pubsub = new PubSub(client, 'systemheart');
    var topic =
    await pubsub.lookupTopic('projects/systemheart/topics/lectureECG');

    var currentDatetime = DateTime.now();
    await topic.publishString(_joinedECGdata.toString(), attributes: {
      'read_date': DateFormat('dd-MM-yyyy:H:m:s').format(currentDatetime),
      'user': '1'
    });*/
  }
}
