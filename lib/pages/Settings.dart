import 'package:five3one/model/user_settings.dart';
import 'package:five3one/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//Plate calc scaffold
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Box<UserSettings> userSettingsBox = Hive.box<UserSettings>('userSettings');

  List roundingList = [
    {'label': 'Up', 'value': 'up', 'isActive': false},
    {'label': 'Nearest', 'value': 'nearest', 'isActive': true},
    {'label': 'Down', 'value': 'down', 'isActive': false}
  ];

  List precisionList = [
    {'label': '2.5', 'value': 2.5, 'isActive': false},
    {'label': '5.0', 'value': 5.0, 'isActive': true},
    {'label': '10.0', 'value': 10.0, 'isActive': false}
  ];

  List trainingMaxPercentList = [
    {'label': '90%', 'value': 0.90, 'isActive': false},
    {'label': '95%', 'value': 0.95, 'isActive': true},
    {'label': '100%', 'value': 1, 'isActive': false}
  ];

  toggleSelection(List arr, num index, String field, bool? dbload) {
    for (int i = 0; i < arr.length; i++)
      i != index ? arr[i][field] = false : arr[i][field] = true;

    if (!dbload!) {
      // update db
      setState(() {
        _setDB();
      });
    }
  }

  @override
  void initState() {
    if (userSettingsBox.get('userSettings')?.createdAt != null) _getDBvals();
    super.initState(); // to have context

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getDBvals() {
    var _rounding = userSettingsBox.get('userSettings')?.rounding;
    if (_rounding != null)
      toggleSelection(
          roundingList,
          roundingList.indexWhere((el) => el['value'] == _rounding),
          'isActive',
          true);

    var _precision = userSettingsBox.get('userSettings')?.precision;
    if (_precision != null)
      toggleSelection(
          precisionList,
          precisionList.indexWhere((el) => el['value'] == _precision),
          'isActive',
          true);

    var _trainingMaxPercent =
        userSettingsBox.get('userSettings')?.trainingMaxPercent;
    if (_trainingMaxPercent != null)
      toggleSelection(
          trainingMaxPercentList,
          trainingMaxPercentList
              .indexWhere((el) => el['value'] == _trainingMaxPercent),
          'isActive',
          true);
  }

  void _setDB() async {
    var userSettings = UserSettings(
        rounding: roundingList.firstWhere((el) => el['isActive'])['value'],
        precision: precisionList.firstWhere((el) => el['isActive'])['value'],
        trainingMaxPercent:
            trainingMaxPercentList.firstWhere((el) => el['isActive'])['value'],
        createdAt: DateTime.now()); //creating new object
    await userSettingsBox.put('userSettings', userSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: colors.general_font_color, //change your color here
          ),
          backgroundColor: colors.secondary,
          centerTitle: true,
          title: Text(
            "Settings",
            style: TextStyle(color: colors.general_font_color),
          ),
        ),
        backgroundColor: colors.background,
        body: Container(
          color: colors.secondary,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rounding: '),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) => toggleSelection(
                            roundingList, index, 'isActive', false),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedColor: Colors.white,
                        fillColor: colors.primary,
                        color: Colors.white,
                        constraints: const BoxConstraints(
                            minHeight: 40.0, minWidth: 80.0),
                        isSelected: [for (var i in roundingList) i['isActive']],
                        children: [
                          for (var i in roundingList) Text(i['label'])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Precision: '),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) => toggleSelection(
                            precisionList, index, 'isActive', false),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedColor: Colors.white,
                        fillColor: colors.primary,
                        color: Colors.white,
                        constraints: const BoxConstraints(
                            minHeight: 40.0, minWidth: 80.0),
                        isSelected: [
                          for (var i in precisionList) i['isActive']
                        ],
                        children: [
                          for (var i in precisionList) Text(i['label'])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Training Max %: '),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) => toggleSelection(
                            trainingMaxPercentList, index, 'isActive', false),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedColor: Colors.white,
                        fillColor: colors.primary,
                        color: Colors.white,
                        constraints: const BoxConstraints(
                            minHeight: 40.0, minWidth: 80.0),
                        isSelected: [
                          for (var i in trainingMaxPercentList) i['isActive']
                        ],
                        children: [
                          for (var i in trainingMaxPercentList) Text(i['label'])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
