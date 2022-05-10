import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/recordecgs.dart';
import 'package:tappecg_ai/constants.dart';

class ListResults extends StatelessWidget {

  final recordecgsRepository = RecordecgsRepository();
  List<Recordecgs> recordecgs = [];
  
  Future<void> makeRequest() async {
    recordecgs = await recordecgsRepository.getRecordecgs();
    print("Hola");
    print(recordecgs.length);
  }

  initState() {
    print("hola si funciona Satea");
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {this.makeRequest();
    return Scaffold(
      body: Column(
        children: [
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
                                ListTile(
                                    leading: FlutterLogo(size: 56.0),
                                    title:
                                        Text(recordecgs[i].labelResult),
                                    subtitle: Text(recordecgs[i].subLabel),

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
