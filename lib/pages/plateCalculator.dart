import 'package:five3one/utils/calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final TextEditingController textfield = TextEditingController();

//Plate calc scaffold
class PlateCalcView extends StatefulWidget {
  const PlateCalcView({super.key});

  @override
  State<PlateCalcView> createState() => _PlateCalcViewState();
}

class _PlateCalcViewState extends State<PlateCalcView> {
  Map<String, num> weightMap = {};

  getPlateCalculations(num weight) {
    weight = (weight / 5).round() * 5;
    if (weight > 45) {
      setState(() {
        weightMap = calcUtil.calculatePlates(weight);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Plate Calculator'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: 200,
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
                      ? (getPlateCalculations(num.parse(val)))
                      : getPlateCalculations(0);
                }),
              ),
            ),
            SizedBox(
              height: 200,
              width: 1000,
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
            ),
          ],
        ));
  }
}
