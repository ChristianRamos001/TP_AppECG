import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/recordecgs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


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

  @override
  initState() {
   makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 2,
          ),
          Container(
            child: const Text("Historial",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey
                      ),
                    ),
          ),
          
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recordecgs == null ? 0 : recordecgs.length,
              itemBuilder: (BuildContext context, int i){
                return Center(
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SfCartesianChart(
                                  borderColor: const Color(0xFF00BCD4),
                                  borderWidth: 2,
                                  margin: const EdgeInsets.all(15),
                                  palette: const <Color>[
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
                                        style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 25,
                                                  color: Color.fromRGBO(208, 218, 40, 1)
                                                ),
                                        ),
                                    subtitle: 
                                        Text(recordecgs[i].subLabel+ " / " + recordecgs[i].readDate.substring(0, 16) ,
                                        style: const TextStyle(
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
