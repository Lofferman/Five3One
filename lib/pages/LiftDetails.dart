import 'package:five3one/model/lift_data.dart';
import 'package:five3one/utils/calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../styles/styles.dart';

//LIFT VIEW WIDGET
class LiftView extends StatefulWidget {
  const LiftView({super.key, required this.lift});

  final String lift;

  @override
  State<LiftView> createState() => _LiftViewState();
}

class _LiftViewState extends State<LiftView> {
  TextEditingController? maxField;
  final FocusNode maxCodeCtrlFocusNode = FocusNode();
  late num maxWeight;

  @override
  void initState() {
    super.initState(); // to have context
    maxField = TextEditingController(text: '135');
    num? storedWeight = _getDBvals();
    _setMaxWeight(storedWeight);
    if (storedWeight != null) maxCodeCtrlFocusNode.requestFocus();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    maxField?.dispose();
  }

  void _setMaxWeight(num? weight) {
    if (weight != null) {
      setState(() {
        maxWeight = weight;
        _setDB(weight, widget.lift);
      });
    }
  }

  _getDBvals() {
    num? storedMax;
    storedMax = liftDataBox.get(widget.lift)?.liftTotal ?? 135;
    print(storedMax);
    maxWeight = (storedMax);
    maxField!.text = storedMax.toString() ?? '';
  }

  void _setDB(weight, lift) async {
    var userdata = LiftData(
        liftTotal: weight,
        liftType: lift,
        createdAt: DateTime.now()); //creating new object

    await liftDataBox.put(userdata.liftType, userdata);
  }

  Box<LiftData> liftDataBox = Hive.box<LiftData>('liftData');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0), // here the desired height
          child: AppBar(
            iconTheme: IconThemeData(
              color: colors.general_font_color, //change your color here
            ),
            backgroundColor: colors.secondary,
            centerTitle: true,
            title: Text(
              widget.lift,
              style: TextStyle(
                color: colors.general_font_color,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // ,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        textAlign: TextAlign.center,
                        cursorColor: Colors.white,
                        maxLength: 6,
                        controller: maxField,
                        focusNode: maxCodeCtrlFocusNode,
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+(?:\.\d{0,2})?$'))
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Enter weight',
                          labelText: '',
                          counterText: "",
                          hintStyle: TextStyle(color: Colors.white30),
                          focusColor: Colors.white,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                            fontSize: 40.0, color: colors.general_font_color),
                        onChanged: (val) => setState(() {
                              _setMaxWeight(num.parse(val));
                            })),
                    SizedBox(
                      height: 30,
                    ),
                    const TabBar(
                      textScaler: TextScaler.linear(1.5),
                      labelColor: Colors.white,
                      indicatorColor: colors.secondary,
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: Colors.white60,
                      tabs: <Widget>[
                        Text("5/5/5+"),
                        Text("3/3/3+"),
                        Text("5/3/1+"),
                        Text("Deload"),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
        body: Container(
          color: colors.primary,
          child: TabBarView(
            children: <Widget>[
              LiftDetails(
                  lift: widget.lift, metric: "5/5/5", weight: maxWeight),
              LiftDetails(
                  lift: widget.lift, metric: "3/3/3", weight: maxWeight),
              LiftDetails(
                  lift: widget.lift, metric: "5/3/1", weight: maxWeight),
              LiftDetails(
                  lift: widget.lift, metric: "Deload", weight: maxWeight),
            ],
          ),
        ),
      ),
    );
  }
}

// CARD WIDGET

class LiftDetails extends StatefulWidget {
  const LiftDetails(
      {super.key,
      required this.lift,
      required this.metric,
      required this.weight});

  final String lift;
  final String metric;
  final num weight;

  @override
  State<LiftDetails> createState() => _LiftDetailsState();
}

class _LiftDetailsState extends State<LiftDetails> {
  List<Map<String, dynamic>> repDetails = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      SetSection(repDetails: calcUtil.calcWeights(widget.metric, widget.weight))
    ]);
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (Map<String, dynamic> item in widget.repDetails)
          LiftDetailsCard(repRange: item['reps'], weight: item['weight']),
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
      color: colors.tertiary,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: LiftDetailsCardContent(
          repRange: repRange,
          weight: weight,
        ),
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
    return Row(children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: [
            Text(
              '$weight',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: colors.general_font_color),
            ),
            Text(
              'lbs',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: colors.general_font_color),
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 10.0,
          children: [
            Text(
              '$repRange',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: colors.general_font_color),
            ),
            Text(
              'reps',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: colors.general_font_color),
            ),
          ],
        ),
      ),
      Flexible(
          flex: 1,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: weightMap.length,
              itemBuilder: (BuildContext context, int index) {
                String key = weightMap.keys.elementAt(index);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(key.replaceAll('.0', ''),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: colors.general_font_color)),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${weightMap[key]?.round()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: colors.general_font_color),
                    ),
                  ],
                );
              },
            ),
            Text(
              'plates per side',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: colors.general_font_color),
            ),
          ]))
    ]);
  }
}
