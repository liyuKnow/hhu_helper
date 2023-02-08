import 'package:hhu_helper/src/widgets/screens/reading/reading_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hhu_helper/src/data/models/models.dart';
import 'package:hhu_helper/src/data/helper/db_helper.dart';
import 'package:hhu_helper/src/widgets/screens/reading/search_readings.dart';

class ReadingsList extends StatefulWidget {
  const ReadingsList({super.key});

  @override
  State<ReadingsList> createState() => _ReadingsListState();
}

class _ReadingsListState extends State<ReadingsList> {
  late Future _readingsList;

  Future _getAllreadings() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchAllReadings();
  }

  @override
  void initState() {
    super.initState();
    _readingsList = _getAllreadings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readingsList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: const [
                  SearchReadings(),
                  Expanded(child: ReadingList()),
                ],
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
