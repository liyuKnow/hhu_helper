import 'package:flutter/material.dart';
import 'package:hhu_helper/src/widgets/screens/reading/reading_card.dart';
import 'package:provider/provider.dart';
import 'package:hhu_helper/src/data/helper/db_helper.dart';

class ReadingList extends StatelessWidget {
  const ReadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.readings;
        return list.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                itemBuilder: (_, i) => ReadingCard(list[i]),
              )
            : const Center(
                child: Text('No Entries Found'),
              );
      },
    );
  }
}
