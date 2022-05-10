class Recordecgs {
  final String id;
  final String userID;
  final String readDate;
  final Data _data;
  final double percentResult;
  final String labelResult;
  final String subLabel;
  Recordecgs(this.id, this.userID, this.readDate, this._data, this.percentResult, this.labelResult, this.subLabel);

  Recordecgs.fromMap(Map<String, dynamic> data) :
  id = data['id'],
  userID = data['userID'],
  readDate = data['readDate'],
  _data = Data.fromMap(data['data']),
  percentResult = data['percentResult'],
  labelResult = data['labelResult'],
  subLabel = data['subLabel'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'readDate': readDate,
      'data': _data,
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

  Data.fromMap(Map<String, dynamic> data) :
  dataECG = data['dataECG'].cast<double>(),
  order = data['order'],
  result = data['result'],
  labelResult = data['labelResult'];

  Map<String, dynamic> toMap() {
    return {
      'dataECG': dataECG,
      'order': order,
      'result': result,
      'labelResult': labelResult
    };
  }

}

