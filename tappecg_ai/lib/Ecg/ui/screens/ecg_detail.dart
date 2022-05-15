import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';

class Ecg_detail extends StatefulWidget {
  
  final Recordecgs ecg;

  const Ecg_detail({Key? key, required this.ecg})
      : super(key: key);

  @override
  _Ecg_detailState createState() => _Ecg_detailState();
}

class _Ecg_detailState extends State<Ecg_detail> {
  bool isAdult = true;

  @override
  Widget build(BuildContext context) {
    final recordecgs =
        widget.ecg;
    return Scaffold(
      body:Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SfCartesianChart(
                                  borderColor: Color(0xFF00BCD4),
                                  borderWidth: 2,
                                  margin: EdgeInsets.all(15),
                                  palette: <Color>[
                                  Color(0xFF4881B9)
                                  ],
                                  series: <ChartSeries>[
                                    LineSeries<double, double>(
                                        dataSource: recordecgs.data[0].dataECG,
                                        xValueMapper: (double item, _) => _.toDouble(),
                                        yValueMapper: (double item, _) => item)
                                  ],
                                      ),
                                ListTile(
                                    title:
                                        Text(recordecgs.labelResult,
                                        style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 25,
                                                  color: Color.fromRGBO(208, 218, 40, 1)
                                                ),
                                        ),
                                    subtitle: 
                                        Text(recordecgs.subLabel,
                                        style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 15,
                                                  color: Colors.grey
                                                ),
                                        ),

                                  ),
                              ]  
                              )
                      )
                    )
                  )
    );
  }
}