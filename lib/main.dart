import 'package:five3one/model/lift_data.dart';
import 'package:five3one/pages/PlateCalculator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:five3one/pages/LiftDetails.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LiftDataAdapter());
  await Hive.openBox<LiftData>('liftData');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color.fromARGB(255, 226, 13, 13),
          cardColor: const Color.fromARGB(255, 184, 88, 85),
          backgroundColor: const Color.fromARGB(255, 71, 64, 64),
          errorColor: Colors.red,
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  List<String> cards = ['Squat', 'Bench', 'Deadlift', 'Plate Calc'];

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Five3One')),
          ),
          body: ListOfModules(cards: cards),
          backgroundColor: const Color.fromARGB(255, 73, 33, 33)),
    );
  }
}

class ListOfModules extends StatelessWidget {
  const ListOfModules({
    super.key,
    required this.cards,
  });

  final List<String> cards;

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
          children: cards.map((data) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    if (data == 'Plate Calc') {
                      return PlateCalcView();
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
