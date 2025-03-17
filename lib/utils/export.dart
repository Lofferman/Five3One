import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class exportUtil {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    print(status);
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<void> writeCounter(String bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    Future<void> _createExcel() async {
      // Create a new Excel Document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // Set the text value.
      sheet.getRangeByName('A1').setText('Hello World!');

      // Save and dispose the document.
      final List<int> bytes = workbook.saveSync();
      workbook.dispose();

      // Save the Excel file in the local machine.
      File('Output.xlsx').writeAsBytes(bytes);
    }
  }
}
