import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tappecg_ai/Ecg/model/dates_abnormalities.dart';
import 'package:tappecg_ai/Ecg/model/list_results_ecg.dart';
import 'package:tappecg_ai/Ecg/repository/recordecgs.dart';
import 'package:tappecg_ai/Ecg/ui/screens/ecg_detail.dart';
import 'package:tappecg_ai/Ecg/ui/screens/navbar.dart';
import 'package:tappecg_ai/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ListResults extends StatefulWidget {
  @override
  ListResultsState createState() => ListResultsState();
}

class ListResultsState extends State<ListResults> {
  Map<DateTime, List<Event>>? selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  final recordecgsRepository = RecordecgsRepository();

  List<Recordecgs> recordecgs = [];
  List<DatesAbnormalities> datesAbnormalities = [];

  initState() {
    selectedEvents = {};
    this.getDatesAbnormalities();
    this.makeRequest();
    super.initState();
  }

  Future<void> makeRequest() async {
    var items = recordecgs = await recordecgsRepository.getRecordecgs();

    setState(() {
      recordecgs = items;
    });
  }

  Future<void> getDatesAbnormalities() async {
    var items2 =
        datesAbnormalities = await recordecgsRepository.getDatesAbnormalities();

    setState(() {
      datesAbnormalities = items2;
      datesAbnormalities.forEach((element) {
        if (selectedEvents![DateFormat("yyyy-MM-dd").format(element.dateResult)] != null) {
          selectedEvents![DateFormat("yyyy-MM-dd").format(element.dateResult)]?.add(
            Event(title: _eventController.text),
          );
        } else {
          selectedEvents![element.dateResult] = [Event(title: element.isAbnormal.toString())];
        }


      });
    });




  }

  List<Event> _getEventsfromDay(DateTime date) {

    var item = DateFormat("yyyy-MM-dd").format(date);
    return selectedEvents![DateTime.parse(item)] ?? [];
  }

  Future<void> makeRequestDate(DateTime date) async {
    var items = recordecgs = await recordecgsRepository.getRecordecgsDate(date);
    setState(() {
      recordecgs = items;
    });
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TableCalendar(
          focusedDay: selectedDay,
          firstDay: DateTime(1990),
          lastDay: DateTime(2050),
          calendarFormat: format,
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.sunday,
          daysOfWeekVisible: true,

          //Day Changed
          onDaySelected: (DateTime selectDay, DateTime focusDay) {
            setState(() {
              makeRequestDate(focusDay);
              selectedDay = selectDay;
              focusedDay = focusDay;
            });
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
          },
          eventLoader:  (day) {

            //print(_getEventsfromDay(day));
            return _getEventsfromDay(day);
          },



          //To style the Calendar
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
            ),
            formatButtonTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          child: Text(
            "Historial",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25, color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: recordecgs == null ? 0 : recordecgs.length,
                itemBuilder: (BuildContext context, int i) {
                  return Center(
                      child: GestureDetector(
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
                                        palette: <Color>[Color(0xFF4881B9)],
                                        series: <ChartSeries>[
                                          LineSeries<double, double>(
                                              dataSource:
                                                  recordecgs[i].data[0].dataECG,
                                              xValueMapper: (double item, _) =>
                                                  _.toDouble(),
                                              yValueMapper: (double item, _) =>
                                                  item)
                                        ],
                                      ),
                                      ListTile(
                                        title: Text(
                                          recordecgs[i].labelResult,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color:
                                                  recordecgs[i].labelResult ==
                                                          "Resultados Anormales"
                                                      ? Color(0xffD9124B)
                                                      : Color.fromRGBO(
                                                          208, 218, 40, 1)),
                                        ),
                                        subtitle: Text(
                                          recordecgs[i].subLabel +
                                              "\n" +
                                              DateFormat("yyyy-MM-dd").format(
                                                  recordecgs[i].readDate),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.grey),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () => goDetails(recordecgs[i]),
                                          child: Container(
                                            height: 40,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF4881B9),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                'Abrir',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ])))),
                  ));
                }))
      ]),
    );
  }

  void goDetails(Recordecgs ecg) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => Ecg_detail(ecg: ecg)));
  }
}

class Event {
  final String title;
  Event({required this.title});

  String toString() => this.title;
}
