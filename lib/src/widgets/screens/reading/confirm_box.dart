import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hhu_helper/src/data/helper/db_helper.dart';
import 'package:hhu_helper/src/data/models/models.dart';

class ConfirmBox extends StatelessWidget {
  final Reading reading;
  const ConfirmBox({required this.reading, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      title: Text('Delete ${reading.customerName} ?'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // don't delete
            },
            child: const Text('Don\'t delete'),
          ),
          const SizedBox(width: 5.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              // on delete
              // provider.deleteExpense(user.id, user.firstName, user.lastName);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
