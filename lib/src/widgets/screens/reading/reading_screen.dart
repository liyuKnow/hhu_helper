import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hhu_helper/src/widgets/screens/reading/readings_list.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as XLSIO;
import 'package:provider/provider.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:hhu_helper/src/controller/permissions_controller.dart';
import 'package:hhu_helper/src/data/helper/db_helper.dart';
import 'package:hhu_helper/src/data/models/reading.dart';
import 'package:hhu_helper/src/core/app_styles.dart';
import 'package:hhu_helper/src/core/size_config.dart';

enum MenuItems { import, export, sync }

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  @override
  void initState() {
    PermissionController.onStartUpPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Readings"),
        centerTitle: true,
        actions: [
          popupActions(),
        ],
      ),
      body: const ReadingsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qr_screen');
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  PopupMenuButton<MenuItems> popupActions() {
    return PopupMenuButton<MenuItems>(
      onSelected: (value) {
        if (value == MenuItems.import) {
          loadData();
        } else if (value == MenuItems.export) {
          _exportData();
        } else if (value == MenuItems.sync) {}
      },
      itemBuilder: ((context) => [
            PopupMenuItem(
              value: MenuItems.import,
              child: Row(
                children: const [
                  Icon(
                    Icons.download,
                    color: Colors.indigo,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text("Import Data"),
                ],
              ),
            ),
            PopupMenuItem(
              value: MenuItems.export,
              child: Row(
                children: const [
                  Icon(
                    Icons.upload,
                    color: Colors.indigo,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text("Export Data"),
                ],
              ),
            ),
            PopupMenuItem(
              value: MenuItems.sync,
              child: Row(
                children: const [
                  Icon(
                    Icons.import_export,
                    color: Colors.indigo,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text("Sync Data"),
                ],
              ),
            ),
          ]),
    );
  }

  loadData() async {
    try {
      // ^ CHECK PERMISSION
      PermissionController.requestManageStorage();

      // ^ GET FILE FROM DOWNLOADS
      final directory = Directory('/storage/emulated/0/Download/');
      const fileName = "reading.xlsx";

      var file = File(directory.path + fileName);

      var isFile = await file.exists();

      if (isFile) {
        // ^ SAVE IT TO A LOCAL VARIABLE
        List<String> rowDetail = [];

        var excelBytes = File(file.path).readAsBytesSync();
        var excelDecoder =
            SpreadsheetDecoder.decodeBytes(excelBytes, update: true);

        for (var table in excelDecoder.tables.keys) {
          for (var row in excelDecoder.tables[table]!.rows) {
            rowDetail.add('$row'.replaceAll('[', '').replaceAll(']', ''));
          }
        }

        insertIntoDb(rowDetail);
      } else {
        const snackBar = SnackBar(
          content: Text(
            "The file specified is not found in the device",
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      return e.toString();
    }
  }

  void insertIntoDb(rowDetail) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);

    provider.truncateTables();

    for (var i = 1; i < rowDetail.length; i++) {
      var data = rowDetail[i].split(',');
      print(data[1]);
      try {
        Reading reading = Reading(
          customerName: data[0],
          customerId: data[1],
          deviceId: data[2],
          meterReading: data[3].toString(),
        );

        print(provider.addReading(reading));
      } catch (e) {
        print(e);
      }
    }

    Navigator.pushNamed(context, '/reading');
  }

  Future<void> _exportData() async {
    // ^ export current database data to downloads folder
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    // Create a new Excel document.
    final XLSIO.Workbook workbook = XLSIO.Workbook();
    //Accessing worksheet via index.
    final XLSIO.Worksheet sheet = workbook.worksheets[0];

    // ADD THE HEADERS
    sheet.getRangeByName('A1').setText('FirstName');
    sheet.getRangeByName('B1').setText('LastName');
    sheet.getRangeByName('C1').setText('Updated');
    sheet.getRangeByName('D1').setText('Age');
    sheet.getRangeByName('E1').setText('Date');

    // GET ALL DATA FROM OBJECT BOX
    // List<User> allUsers = await provider.fetchUsers();

    // for (var i = 2; i < allUsers.length; i++) {
    //   sheet.getRangeByName('A$i').setText((allUsers[i].firstName).toString());
    //   sheet.getRangeByName('B$i').setText((allUsers[i].lastName).toString());
    //   sheet.getRangeByName('C$i').setText((allUsers[i].updated).toString());
    //   sheet.getRangeByName('D$i').setText((allUsers[i].age).toString());
    //   sheet.getRangeByName('E$i').setText((allUsers[i].date).toString());
    // }

    final List<int> bytes = workbook.saveAsStream();

    final directory = Directory('/storage/emulated/0/Download/');
    const fileName = "GeneratedUsersDownload.xlsx";
    final file = File(directory.path + fileName);

    file.writeAsBytes(bytes);

    //Dispose the workbook.
    workbook.dispose();
  }
}




// body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: kPaddingHorizontal,
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: SizeConfig.blockSizeVertical! * 3,
//               ),
//               TextField(
//                 decoration: InputDecoration(
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(kBorderRadius),
//                       borderSide: const BorderSide(width: 1, color: kGrayColor),
//                     ),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(
//                           kBorderRadius,
//                         ),
//                         borderSide: const BorderSide(
//                           width: 1,
//                           color: kGrayColor,
//                         )),
//                     prefixIcon: const Icon(Icons.search),
//                     hintText: "Search readingScreens"),
//                 style: kQuestrialMedium.copyWith(
//                     fontSize: SizeConfig.blockSizeHorizontal! * 4,
//                     color: kDarkGrayColor),
//               ),
//             ],
//           ),
//         ),
//       ),