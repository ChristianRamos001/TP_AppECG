import 'package:intl/intl.dart';

class DatesAbnormalities {
  final DateTime dateResult;
  final bool isAbnormal;
  DatesAbnormalities(this.dateResult, this.isAbnormal);

  DatesAbnormalities.fromMap(Map<String, dynamic> item) :

        dateResult = DateFormat('MM/dd/yyyy').parse(item['dateResult']),
        isAbnormal = item['isAbnormal'];

  Map<String, dynamic> toMap() {
    return {
      'dateResult': dateResult,
      'isAbnormal': isAbnormal,
    };
  }
}