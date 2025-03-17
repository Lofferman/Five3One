import 'package:five3one/utils/calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/styles.dart';

//Plate calc scaffold
class PlateCalcView extends StatefulWidget {
  const PlateCalcView({super.key});

  @override
  State<PlateCalcView> createState() => _PlateCalcViewState();
}

class _PlateCalcViewState extends State<PlateCalcView> {
  Map<String, num> weightMap = {};
  TextEditingController? plateController;
  final FocusNode plateCodeCtrlFocusNode = FocusNode();

  getPlateCalculations(num weight) {
    weight = (weight / 5).round() * 5;
    if (weight > 45) {
      setState(() {
        weightMap = calcUtil.calculatePlates(weight);
      });
    }
  }

  @override
  void initState() {
    super.initState(); // to have context
    plateController = TextEditingController(text: '135');
    plateCodeCtrlFocusNode.requestFocus();
    getPlateCalculations(135);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    plateController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(150.0), // here the desired height
            child: AppBar(
                iconTheme: IconThemeData(
                  color: colors.general_font_color, //change your color here
                ),
                backgroundColor: colors.secondary,
                centerTitle: true,
                title: Text(
                  "Plate Calculator",
                  style: TextStyle(color: colors.general_font_color),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          textAlign: TextAlign.center,
                          cursorColor: colors.general_font_color,
                          maxLength: 6,
                          controller: plateController,
                          focusNode: plateCodeCtrlFocusNode,
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
                            val != ''
                                ? (getPlateCalculations(num.parse(val)))
                                : getPlateCalculations(0);
                          }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                ))),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            if (plateController!.text.isNotEmpty &&
                plateController!.text.length > 2) ...[
              Expanded(
                flex: 2,
                child: Container(
                  child: ListView.builder(
                    itemCount: weightMap.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = weightMap.keys.elementAt(index);
                      return Card(
                          color: colors.tertiary,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "$key x ${weightMap[key]?.round()}",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: colors.general_font_color),
                            ),
                          ));
                    },
                  ),
                ),
              ),
              Center(
                child: Text('Assumes 45lb bar',
                    style: TextStyle(color: colors.tertiary)),
              ),
              Center(
                child: Text('**Add these plates to each of the of barbell**',
                    style: TextStyle(color: colors.tertiary)),
              )
            ],
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
