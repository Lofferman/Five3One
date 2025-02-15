import 'package:five3one/utils/calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> cards = ['Squat', 'Bench', 'Deadlift', 'Plate Calculator'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Five3One')),
        ),
        body: ListView(
          children: List.generate(
            cards.length,
            (index) => Padding(
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _LiftView(
                        lift: cards[index],
                      ),
                    ),
                  ),
                },
                child: Card.filled(
                  color: Color(0xff5A96D3),
                  elevation: 10,
                  child: _SampleCard(cardName: cards[index]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// CARD WIDGET
class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName});

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 150, child: Center(child: Text(cardName)));
  }
}

//LIFT VIEW WIDGET
class _LiftView extends StatelessWidget {
  const _LiftView({required this.lift});

  final String lift;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lift),
          bottom: const TabBar(
            tabs: <Widget>[
              Text("5/5/5"),
              Text("3/3/3"),
              Text("5/3/1"),
              Text("Deload"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            LiftDetails(lift: lift, metric: "5/5/5"),
            LiftDetails(lift: lift, metric: "3/3/3"),
            LiftDetails(lift: lift, metric: "5/3/1"),
            LiftDetails(lift: lift, metric: "Deload"),
          ],
        ),
      ),
    );
  }
}

// CARD WIDGET

class LiftDetails extends StatefulWidget {
  const LiftDetails({super.key, required this.lift, required this.metric});

  final String lift;
  final String metric;

  @override
  State<LiftDetails> createState() => _LiftDetailsState();
}

class _LiftDetailsState extends State<LiftDetails> {
  final TextEditingController textfield = TextEditingController();
  List<Map<String, dynamic>> result = [];
  //TODO: Add cache
  num maxWeight = 0.0;

  void _setMaxWeight(num weight) {
    setState(() {
      result = calcUtil.calcWeights(widget.metric, weight);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(result);
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // spacing: 10.0,
          children: [
            Card.filled(
              color: Color(0xff5A96D3),
              margin: EdgeInsets.all(10),
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.0,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10.0,
                      children: [
                        Text(
                          'Max Lift:',
                          style: TextStyle(fontSize: 40),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10.0,
                      children: [
                        SizedBox(
                            width: 50,
                            child: TextFormField(
                              maxLength: 4,
                              controller: textfield,
                              autovalidateMode: AutovalidateMode.always,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                hintText: '',
                                labelText: '',
                              ),
                              onChanged: (val) => setState(() {
                                val != ''
                                    ? _setMaxWeight(num.parse(val))
                                    : _setMaxWeight(0);
                              }),
                              // validator: (value) {
                              //   if (value != null) {
                              //     return value.contains('@')
                              //         ? 'Do not use the @ char.'
                              //         : null;
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            result.isNotEmpty
                ? Column( children: [
                  SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: List.generate(
                      result.length,
                      (index) {
                        return LiftDetailsCard(
                            repRange: result[index]["reps"] ?? 0.0,
                            weight: result[index]["weight"] ?? 0.0);
                      },
                    ),
                  ),
                ],)

                : Center(child: Text('Add a max Weight'))
          ],
        ),
    ),
      ],
    );
  }
}

// CARD WIDGET
class LiftDetailsCard extends StatelessWidget {
  const LiftDetailsCard(
      {super.key, required this.repRange, required this.weight});

  final num repRange;
  final num weight;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card.filled(
      color: Color(0xff5A96D3),
      margin: EdgeInsets.all(10),
      child: LiftDetailsCardContent(
        repRange: repRange,
        weight: weight,
      ),
    ));
  }
}

// CARD WIDGET
class LiftDetailsCardContent extends StatelessWidget {
  const LiftDetailsCardContent(
      {super.key, required this.repRange, required this.weight});

  final num repRange;
  final num weight;

  @override
  Widget build(BuildContext context) {
    var platesRequired =
        WeightPlateUtil.calculatePlates(weight).entries.toList();
    print(WeightPlateUtil.calculatePlates(weight));
    return SizedBox(
      height: 150,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          spacing: 50,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10.0,
              children: [
                Text(
                  '$weight',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10.0,
              children: [
                Text(
                  'x $repRange',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
            Column(
              children: [
                // Text(
                //   'Plates Per side',
                // ),
                // platesRequired.contains(45) != null
                //     ? Text('45 x + ${platesRequired[45].value}')
                //     : Text(''),
                // platesRequired[25] != null
                //     ? Text('25 x ${platesRequired[25]}')
                //     : Text(''),
                // platesRequired[10] != null
                //     ? Text('10 x ${platesRequired[10]}')
                //     : Text(''),
                // platesRequired[5] != null
                //     ? Text('5 x ${platesRequired[5]}')
                //     : Text(''),
                // platesRequired[2] != null
                //     ? Text('2.5 x ${platesRequired[2]}')
                //     : Text(''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
