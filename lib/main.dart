import 'dart:developer';

import 'package:five3one/model/lift_data.dart';
import 'package:five3one/model/user_settings.dart';
import 'package:five3one/pages/Export.dart';
import 'package:five3one/pages/LiftDetails.dart';
import 'package:five3one/pages/PlateCalculator.dart';
import 'package:five3one/pages/Settings.dart';
import 'package:five3one/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await Hive.initFlutter();

  //loading lift data store
  Hive.registerAdapter(LiftDataAdapter());
  await Hive.openBox<LiftData>('liftData');

  // Loading userSettings data store
  Hive.registerAdapter(UserSettingsAdapter());
  await Hive.openBox<UserSettings>('userSettings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            color: colors.general_font_color,
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.oswald(
            color: colors.general_font_color,
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(
            color: colors.general_font_color,
          ),
          displaySmall: GoogleFonts.pacifico(
            color: colors.general_font_color,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  List<String> cards = [
    'Squat',
    'Bench',
    'Deadlift',
    'Overhead Press',
    'Plate Calc',
    'Settings',
    // 'Export', //Under development
  ];

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colors.secondary,
          title: Center(
            child: Text(
              'FIVE3ONE',
              style: TextStyle(color: colors.general_font_color),
            ),
          ),
        ),
        body: ListOfModules(cards: cards),
        backgroundColor: colors.background,
      ),
    );
  }
}

class ListOfModules extends StatefulWidget {
  const ListOfModules({
    super.key,
    required this.cards,
  });

  final List<String> cards;

  @override
  State<ListOfModules> createState() => _ListOfModulesState();
}

class _ListOfModulesState extends State<ListOfModules> {
  void initState() {
    super.initState(); // to have context
    CheckPermissions();
    setState(() {});
  }

  CheckPermissions() async {
    if (await Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      log('Permission Denied: ${Permission.storage}');
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.vertical, children: [
      Flexible(
        child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          crossAxisCount: 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          children: widget.cards.map((data) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    if (data == 'Plate Calc') {
                      return PlateCalcView();
                    }
                    if (data == 'Settings') {
                      return SettingsView();
                    }
                    if (data == 'Export') {
                      return ExportView();
                    }
                    return LiftView(lift: data);
                  }),
                );
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card.filled(
                      child: GeneralCard(cardName: data),
                    ),
                  ]),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}

// CARD WIDGET
class GeneralCard extends StatelessWidget {
  const GeneralCard({super.key, required this.cardName});

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: Container(
          color: colors.secondary,
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
          ),
        ));
  }
}
