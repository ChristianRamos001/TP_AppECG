import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/recordecgs.dart';
import 'package:tappecg_ai/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


class ListResults extends StatefulWidget {
  @override
  ListResultsState createState() => ListResultsState();
}

class ListResultsState extends State<ListResults> {

  final recordecgsRepository = RecordecgsRepository();
  List<Recordecgs> recordecgs = [];
  
  Future<void> makeRequest() async {
    var items = recordecgs = await recordecgsRepository.getRecordecgs();
    setState(() {
      recordecgs = items;
    });
  }

  initState() {
   this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 2,
          ),
          Container(
            child: Text("Historial",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey
                      ),
                    ),
          ),
          
          SizedBox(
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: recordecgs == null ? 0 : recordecgs.length,
              itemBuilder: (BuildContext context, int i){
                return Center(
                  child: Card(
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
                                        dataSource: recordecgs[i].data[0].dataECG,
                                        xValueMapper: (double item, _) => _.toDouble(),
                                        yValueMapper: (double item, _) => item)
                                  ],
                                      ),
                                ListTile(
                                    title:
                                        Text(recordecgs[i].labelResult,
                                        style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 25,
                                                  color: Color.fromRGBO(208, 218, 40, 1)
                                                ),
                                        ),
                                    subtitle: 
                                        Text(recordecgs[i].subLabel,
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
              )
          )

        ]
      ),
    );
  }

}
