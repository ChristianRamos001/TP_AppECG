class Recordecgs {
  final String id;
  final String userID;
  final String readDate;
  final List<Data> data;
  final double percentResult;
  final String labelResult;
  final String subLabel;
  Recordecgs(this.id, this.userID, this.readDate, this.data, this.percentResult, this.labelResult, this.subLabel);

  Recordecgs.fromMap(Map<String, dynamic> item) :
  id = item['id'],
  userID = item['userID'],
  readDate = item['readDate'],
  percentResult = item['percentResult'],
  labelResult = item['labelResult'],
  data = item['data'].map((item) => Data.fromMap(item)).toList().cast<Data>(),
  subLabel = item['subLabel'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'readDate': readDate,
      'data': data,
      'percentResult': percentResult,
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

