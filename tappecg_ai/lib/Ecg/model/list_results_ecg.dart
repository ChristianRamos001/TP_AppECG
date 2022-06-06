class Recordecgs {
  final String id;
  final String userID;
  final DateTime readDate;
  final List<Data> data;
  final String labelResult;
  final String subLabel;
  Recordecgs(this.id, this.userID, this.readDate, this.data, this.labelResult, this.subLabel);

  Recordecgs.fromMap(Map<String, dynamic> item) :
  id = item['id'],
  userID = item['userID'],
  readDate = DateTime.parse(item['readDate']),
  labelResult = item['labelResult'],
  data = item['data'].map((item) => Data.fromMap(item)).toList().cast<Data>(),
  subLabel = item['subLabel'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'readDate': readDate,
      'data': data,
      'labelResult': labelResult,
      'subLabel': subLabel
    };
  }
}

class Data {
  final List<double> dataECG;
  final int order;
  final String result;
  final String labelResult;
  Data(this.dataECG, this.order, this.result, this.labelResult);

  Data.fromMap(Map<String, dynamic> item) :
  order = item['order'],
  result = item['result'],
  dataECG = item['dataECG'].cast<double>(),
  labelResult = item['labelResult'];

  Map<String, dynamic> toMap() {
    return {
      'dataECG': dataECG,
      'order': order,
      'result': result,
      'labelResult': labelResult
    };
  }

}

class Recordecg {
  final String id;
  final String userID;
  final DateTime readDate;
  final List<double> data;
  final String labelResult;
  final String subLabel;
  final String type;
  final String commentUser;
  Recordecg(this.id, this.userID, this.readDate, this.data, this.labelResult, this.subLabel, this.type, this.commentUser);

  Recordecg.fromMap(Map<String, dynamic> item) :
        id = item['id'],
        userID = item['userID'],
        readDate = DateTime.parse(item['readDate']),
        labelResult = item['labelResult'],
        data = item['data'].cast<double>(),
        subLabel = item['subLabel'],
        type = item['type'],
        commentUser = item['commentUser'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'readDate': readDate,
      'data': data,
      'labelResult': labelResult,
      'subLabel': subLabel
    };
  }
}

