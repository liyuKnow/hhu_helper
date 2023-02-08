import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hhu_helper/src/data/models/models.dart';
import 'package:hhu_helper/src/widgets/screens/reading/confirm_box.dart';

class ReadingCard extends StatelessWidget {
  final Reading reading;
  const ReadingCard(this.reading, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey(reading.id),
      onTap: (() {
        Navigator.pushNamed(context, '/edit_reading', arguments: reading.id);
      }),
      child: ListTile(
        title: Text("${reading.customerName}  id = ${reading.id}"),
        subtitle: Text(
          // "${DateFormat('MMMM dd, yyyy').format(DateTime.parse(reading.readingDate))}, Updated = ${reading.status}",
          "Updated = ${reading.status}",
        ),
        trailing: IconButton(
          onPressed: () {
            // go to qr page
            Navigator.pushNamed(context, '/edit_reading',
                arguments: reading.id);
          },
          icon: const Icon(
            Icons.edit,
          ),
        ),
      ),
    );
  }
}
