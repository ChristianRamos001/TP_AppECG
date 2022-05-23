import 'package:tappecg_ai/Ecg/model/send_ecg.dart';

import 'event_hub_api.dart';

class RepositoryECG {
  final eventHubAPI = EventHubAPI();

  Future<String> postECGData(SendECG modelSendECG) =>
      eventHubAPI.postECGData(modelSendECG);
}
