import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/ui/screens/navbar.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';

import '../../../constants.dart';
import '../../repository/recordecgs.dart';

class Ecg_detail extends StatefulWidget {
  final Recordecgs ecg;

  const Ecg_detail({Key? key, required this.ecg}) : super(key: key);

  @override
  _Ecg_detailState createState() => _Ecg_detailState();
}

class _Ecg_detailState extends State<Ecg_detail> {
  bool isAdult = true;
  var recordecgs;
  final recordecgsRepository = RecordecgsRepository();
  var isLoading = true;
  initState() {
    makeRequest();
    super.initState();
  }

  Future<void> makeRequest() async {
    var items = await recordecgsRepository.getRecordecg(widget.ecg.id);

    setState(() {
      isLoading = !isLoading;
      recordecgs = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        body: Card(
            child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: isLoading
                        ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    )
                        :Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Registro de Electrocardiograma',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20,
                                    color: darkPrimaryColor
                                ),

                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Fecha: " + DateFormat("yyyy-MM-dd").format(recordecgs.readDate),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Hora: " + DateFormat("hh:mm").format(recordecgs.readDate),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Resultado: " + recordecgs.labelResult,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: recordecgs.labelResult == "Resultados Anormales" ? Color(0xffD9124B) : Color.fromRGBO(208, 218, 40, 1)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tipo de registro: " + recordecgs.type,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SfCartesianChart(
                            primaryXAxis: NumericAxis(
                                visibleMinimum: 2,
                                visibleMaximum: 400
                            ),
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePanning: true,
                            ),
                            borderWidth: 2,
                            margin: EdgeInsets.all(15),
                            palette: <Color>[Color(0xFF4881B9)],
                            series: <ChartSeries>[
                              LineSeries<double, double>(
                                  dataSource: recordecgs.data,
                                  xValueMapper: (double item, _) =>
                                      _.toDouble(),
                                  yValueMapper: (double item, _) => item)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Comentarios: \n" + recordecgs.commentUser,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),

                        ])))));
  }
}
