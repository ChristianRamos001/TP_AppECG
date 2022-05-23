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
      expandedValue: "Details for Book goes here",
      headerValue: 'Book ',
    ),
    Item(
      expandedValue: "Details for Book goes here",
      headerValue: 'Book ',
    ),
    Item(
      expandedValue: "Details for Book goes here",
      headerValue: 'Book ',
    ),
    Item(
      expandedValue: "Details for Book goes here",
      headerValue: 'Book ',
    ),
    Item(
      expandedValue: "Details for Book goes here",
      headerValue: 'Book ',
    ),
    Item(
      expandedValue: "Details for Book goes here",
      headerValue: 'Book ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        drawer: NavBar(),
        body: Column(children: [
          const SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              child: const Text("Preguntas Frecuentes",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.green
                ),
              ),
            ),
          ),
          const SizedBox(
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
        ]));
  }
}
