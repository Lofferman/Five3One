import 'dart:developer';

import 'package:five3one/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../styles/styles.dart';

//Plate calc scaffold
class ExportView extends StatefulWidget {
  const ExportView({super.key});

  @override
  State<ExportView> createState() => _ExportViewState();
}

class _ExportViewState extends State<ExportView> {
  Map<String, num> weightMap = {};

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? forceErrorText;
  bool isLoading = false;
  bool checkboxValue1 = true;
  bool checkboxValue2 = true;
  bool checkboxValue3 = true;
  bool checkboxValue4 = true;

  @override
  void initState() {
    super.initState(); // to have context
    requestStoragePermission();
    setState(() {});
  }

  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    inspect(status);

    if (status.isGranted) {
      inspect(status);

      // Time to store some data!
    } else if (status.isDenied) {
      inspect(status);
      handlePermanentDenial();
      // No storage for us, back to the drawing board
    }
  }

  Future<void> handlePermanentDenial() async {
    bool isPermanentlyDenied = await Permission.camera.isPermanentlyDenied;
    if (isPermanentlyDenied) {
      // Time to show them the way to settings
      openAppSettings();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length != value.replaceAll(' ', '').length) {
      return 'Username must not contain any spaces';
    }
    if (int.tryParse(value[0]) != null) {
      return 'Username must not start with a number';
    }
    if (value.length <= 2) {
      return 'Username should be at least 3 characters long';
    }
    return null;
  }

  void onChanged(String value) {
    // Nullify forceErrorText if the input changed.
    if (forceErrorText != null) {
      setState(() {
        forceErrorText = null;
      });
    }
  }

  var myList = [
    {
      "title": "How to Add .env File in Flutter?",
      "link": "https://www.geeksforgeeks.org/how-to-add-env-file-in-flutter/"
    },
    {
      "title": "Flutter - Select Single and Multiple Files From Device",
      "link":
          "https://www.geeksforgeeks.org/flutter-select-single-and-multiple-files-from-device/"
    },
    {
      "title": "Autofill Hints Suggestion List in Flutter",
      "link":
          "https://www.geeksforgeeks.org/autofill-hints-suggestion-list-in-flutter/"
    },
    {
      "title": "How to Integrate Razorpay Payment Gateway in Flutter?",
      "link":
          "https://www.geeksforgeeks.org/how-to-integrate-razorpay-payment-gateway-in-flutter/"
    },
    {
      "title": "How to Setup Multiple Flutter Versions on Mac?",
      "link":
          "https://www.geeksforgeeks.org/how-to-setup-multiple-flutter-versions-on-mac/"
    },
    {
      "title": "How to Change Package Name in Flutter?",
      "link":
          "https://www.geeksforgeeks.org/how-to-change-package-name-in-flutter/"
    },
    {
      "title":
          "Flutter - How to Change App and Launcher Title in Different Platforms",
      "link":
          "https://www.geeksforgeeks.org/flutter-how-to-change-app-and-launcher-title-in-different-platforms/"
    },
    {
      "title": "Custom Label Text in TextFormField in Flutter",
      "link":
          "https://www.geeksforgeeks.org/custom-label-text-in-textformfield-in-flutter/"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colors.primary,
          centerTitle: true,
          title: Text("Export"),
        ),
        backgroundColor: colors.background,
        body: Column(
          children: [
            Container(
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                CheckboxListTile(
                  value: checkboxValue1,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue1 = value!;
                    });
                  },
                  title: const Text('Squat'),
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  value: checkboxValue2,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue2 = value!;
                    });
                  },
                  title: const Text('Bench'),
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  value: checkboxValue3,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue3 = value!;
                    });
                  },
                  title: const Text('Deadlift'),
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  value: checkboxValue4,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue4 = value!;
                    });
                  },
                  title: const Text('Overhead Press'),
                ),
                const Divider(height: 0),
                SizedBox(
                  height: 20,
                ),
              ]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^([^.]+)$'))
                  ],
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: 'Please write a username'),
                  validator: validator,
                  onChanged: onChanged,
                ),
                const SizedBox(height: 40.0),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  TextButton(
                      child: const Text('Save'),
                      onPressed: () {
                        exportUtil.writeCounter(
                            myList.toString(), "geeksforgeeks.txt");
                      }),
              ],
            ),
          ],
        ));
  }
}
