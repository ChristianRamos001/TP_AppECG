import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/navbar.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class _FaqState extends State<Faq> {
  List<Item> faqs = [
    Item(
      headerValue: "¿Puedo realizar conexion con otros dispositivos werables?",
      expandedValue: 'No, solo puede realizarse con el werable ¨polar H10¨ ',
    ),
    Item(
      headerValue: "¿La aplicaciòn manda informaciòn a un solo mèdico?",
      expandedValue: "Manda el resultado de sus ECG's a todos los médicos que le fueron asignados",
    ),
    Item(
      headerValue: "¿Que debo hacer si tengo una lectura anormal?",
      expandedValue: 'Debe acudir a su medico para realizar pruebas de descarte inmediatamente ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 2,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                child: Text("Preguntas Frecuentes",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.green
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  faqs[index].isExpanded = !isExpanded;
                });
              },
              children: faqs.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(item.headerValue),
                    );
                  },
                  body: ListTile(
                    title: Text(item.expandedValue),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ]),
        ));
  }
}
