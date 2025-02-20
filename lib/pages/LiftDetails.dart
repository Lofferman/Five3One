import 'package:five3one/model/lift_data.dart';
import 'package:five3one/utils/calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

// CARD WIDGET
class GeneralCard extends StatelessWidget {
  const GeneralCard({super.key, required this.cardName});

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cardName,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ));
  }
}

//LIFT VIEW WIDGET
class LiftView extends StatelessWidget {
  const LiftView({super.key, required this.lift});

  final String lift;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lift),
        ),
        body: TabBarView(
          children: <Widget>[
            LiftDetails(lift: lift, metric: "5/5/5"),
            LiftDetails(lift: lift, metric: "3/3/3"),
            LiftDetails(lift: lift, metric: "5/3/1"),
            LiftDetails(lift: lift, metric: "Deload"),
          ],
        ),
        bottomNavigationBar: const TabBar(
          textScaler: TextScaler.linear(1.5),
          tabs: <Widget>[
            Text("5/5/5+"),
            Text("3/3/3+"),
            Text("5/3/1+"),
            Text("Deload"),
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
  List<Map<String, dynamic>> repDetails = [];

  num maxWeight = 0.0;

  Box<LiftData> liftDataBox = Hive.box<LiftData>('liftData');

  @override
  void initState() {
    super.initState();
    num? storedWeight = _getDBvals();
    _setMaxWeight(storedWeight ?? maxWeight);
  }

  void _setMaxWeight(num weight) {
    setState(() {
      repDetails = calcUtil.calcWeights(widget.metric, weight);
      _setDB(weight, widget.lift);
    });
  }

  _getDBvals() {
    num? storedMax;
    storedMax = liftDataBox.get(widget.lift)?.liftTotal;
    maxWeight = storedMax ?? 0;
    textfield.text = maxWeight.toString();
  }

  void _setDB(weight, lift) async {
    var userdata = LiftData(
        liftTotal: weight,
        liftType: lift,
        createdAt: DateTime.now()); //creating new object

    await liftDataBox.put(userdata.liftType, userdata);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      children: [
        Container(
          child: Center(
            child: Card.filled(
              margin: EdgeInsets.all(10),
              child: Row(
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
                              ? (_setMaxWeight(num.parse(val)))
                              : _setMaxWeight(0);
                        }),
                      ))
                ],
              ),
            ),
          ),
        ),
        SetSection(repDetails: repDetails)
      ],
    );
  }
}

class SetSection extends StatefulWidget {
  const SetSection({
    super.key,
    required this.repDetails,
  });

  final List<Map<String, dynamic>> repDetails;

  @override
  State<SetSection> createState() => _SetSectionState();
}

class _SetSectionState extends State<SetSection> {
  List<num> progressInd = List.empty();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (Map<String, dynamic> item in widget.repDetails)
          Container(
              color: Colors.green,
              child:
                  // ElevatedButton(
                  //     style: ElevatedButton.styleFrom(minimumSize: Size(200, 60)),
                  //     onPressed: () => {
                  //           // progressInd
                  //           //         .any((e) => e == widget.repDetails.indexOf(item))
                  //           //     ? progressInd.remove(widget.repDetails.indexOf(item))
                  //           //     : progressInd.add(widget.repDetails.indexOf(item))
                  //         },
                  //     child:
                  LiftDetailsCard(
                      repRange: item['reps'], weight: item['weight'])),
        // )
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
    return Card.filled(
      margin: EdgeInsets.all(10),
      child: LiftDetailsCardContent(
        repRange: repRange,
        weight: weight,
      ),
    );
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
    Map<String, num> weightMap = {};
    if (weight > 45) {
      weightMap = calcUtil.calculatePlates(weight);
    }
    return SizedBox(
      height: 150,
      width: 20,
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
          SizedBox(
            height: 200,
            width: 100,
            child: ListView.builder(
              itemCount: weightMap.length,
              itemBuilder: (BuildContext context, int index) {
                String key = weightMap.keys.elementAt(index);
                return Column(
                  children: <Widget>[
                    Text("$key - ${weightMap[key]}"),
                    Divider(
                      height: 2.0,
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
