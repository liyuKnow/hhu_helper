import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hhu_helper/src/data/helper/db_helper.dart';

class SearchReadings extends StatefulWidget {
  const SearchReadings({super.key});

  @override
  State<SearchReadings> createState() => _SearchReadingsState();
}

class _SearchReadingsState extends State<SearchReadings> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        provider.searchText = value;
      },
      decoration: const InputDecoration(
        labelText: 'Search Users',
      ),
    );
  }
}
