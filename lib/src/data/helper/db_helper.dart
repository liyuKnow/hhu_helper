import 'package:flutter/material.dart';
import 'package:hhu_helper/src/data/models/reading.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hhu_helper/src/data/models/models.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners();
    // when the value of the search text changes it will notify the widgets.
  }

  List<Reading> _readings = [];
  List<Reading> get readings {
    return _searchText != ''
        ? _readings
            .where((e) => e.customerName
                .toLowerCase()
                .contains(_searchText.toLowerCase()))
            .toList()
        : _readings;
  }

  // User? _user;
  // User? get user => _user;

  // UpdateLocation? _updateLocation;
  // UpdateLocation? get updateLocation => _updateLocation;

  // List<int> _userIds = [];
  // List<int> get userIds => _userIds;

  // COMPLETES OUR DATABASE CREATION
  Database? _database;
  Future<Database> get database async {
    // database directory
    final dbDirectory = await getDatabasesPath();
    // database name
    const dbName = 'report_10.db';
    // full path
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(path,
        version: 1,
        onCreate: _createDb,
        onConfigure: _onConfigure // will create this separately
        );

    return _database!;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // _createDb function
  static const readingTable = 'readings';
  static const updateLocationTable = 'update_locations';
  Future<void> _createDb(Database db, int version) async {
    // this method runs only once. when the database is being created
    // so create the tables here and if you want to insert some initial values
    // insert it in this function.

    await db.transaction((txn) async {
      // category table
      await txn.execute('''CREATE TABLE $readingTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT,
        customerId TEXT,
        deviceId TEXT,
        meterReading TEXT,
        status INTEGER DEFAULT 0,
        readingDate VARCHAR
      )''');

      // expense table
      await txn.execute('''CREATE TABLE $updateLocationTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lat VARCHAR,
        long VARCHAR,
        updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        readingId INTEGER, 
        FOREIGN KEY (readingId) REFERENCES readings (id) ON DELETE CASCADE ON UPDATE CASCADE
      )''');
    });
  }

  // DELETE PREVIOUS RECORDS AND RESET DATABASE TABLE INDEX BACK TO 1
  Future<void> truncateTables() async {
    final db = await database;
    var sql = """ 
              DELETE FROM $readingTable ;    
              DELETE FROM $updateLocationTable ; 
              """;

    var seq_sql = """    
              UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='users';
              UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='update_locations';
              """;

    await db.transaction(((txn) {
      return txn.rawQuery(sql);
    }));

    try {
      await db.transaction(((txn) {
        return txn.rawQuery(seq_sql);
      }));
    } catch (e) {
      print(e);
    }

    return;
  }

  Future<void> addReading(Reading reading) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(
        readingTable,
        reading.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId) {
        // after inserting in a database. we store it in in-app memory with new expense with generated id
        final file = Reading(
            customerName: reading.customerName,
            customerId: reading.customerId,
            deviceId: reading.deviceId,
            meterReading: reading.meterReading);
        // add it to '_expenses'

        _readings.add(file);
        // notify the listeners about the change in value of '_expenses'
        notifyListeners();
      });
    });
  }

  // CRUD OPERATIONS
  Future<List<Reading>> fetchAllReadings() async {
    // get the database
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(readingTable, where: "status == 0").then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'users'from every 'map' in this 'converted'
        List<Reading> nList = List.generate(
            converted.length,
            (index) => Reading.fromJson(
                  converted[index],
                ));
        // set the value of 'categories' to 'nList'
        _readings = nList;
        // return the '_categories'
        return _readings;
      });
    });
  }

  // Future<List<User>> fetchUsers() async {
  //   // get the database
  //   final db = await database;
  //   return await db.transaction((txn) async {
  //     return await txn.query(userTable).then((data) {
  //       // 'data' is our fetched value
  //       // convert it from "Map<String, object>" to "Map<String, dynamic>"
  //       final converted = List<Map<String, dynamic>>.from(data);
  //       // create a 'users'from every 'map' in this 'converted'
  //       List<User> nList = List.generate(
  //           converted.length,
  //           (index) => User.fromJson(
  //                 converted[index],
  //               ));
  //       // set the value of 'categories' to 'nList'
  //       _users = nList;
  //       // return the '_categories'
  //       return _users;
  //     });
  //   });
  // }

  // Future<void> addMany(Map<String, Object?> users) async {
  //   final db = await database;
  //   Batch batch = db.batch();
  //   batch.insert(
  //     userTable,
  //     users,
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<User?> getUserById(int id) async {
  //   final db = await database;

  //   var result = await db.rawQuery('SELECT * FROM $userTable WHERE id=?', [id]);

  //   final converted = User.fromJson(result[0]);

  //   _user = converted;

  //   notifyListeners();
  //   return _user;
  // }

  // Future<UpdateLocation?> getUpdatedLocationByUserId(int userId) async {
  //   final db = await database;

  //   var result = await db.rawQuery(
  //       'SELECT * FROM $updateLocationTable WHERE userId=?', [userId]);

  //   final converted = UpdateLocation.fromJson(result[0]);

  //   _updateLocation = converted;

  //   notifyListeners();
  //   return _updateLocation;
  // }

  // Future<void> updateUser(User user) async {
  //   final db = await database;
  //   await db.transaction((txn) async {
  //     await txn.update(
  //       userTable, // category table
  //       user.toJson(),
  //       where: 'id == ?', // in table where the title ==
  //       whereArgs: [user.id], // this category.
  //     ).then((_) {
  //       notifyListeners();
  //     });
  //   });
  // }

  // Future<void> addUpdateLocation(UpdateLocation updateLocation) async {
  //   final db = await database;

  //   await db.transaction((txn) async {
  //     await txn.insert(
  //       updateLocationTable,
  //       updateLocation.toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   });
  // }

  // Future<List<int>> getUserIds() async {
  //   final db = await database;
  //   return await db.transaction((txn) async {
  //     return await txn.query(userTable, where: "updated == 0").then((data) {
  //       var ids = [];
  //       final converted = List<Map<String, dynamic>>.from(data);
  //       // create a 'users'from every 'map' in this 'converted'
  //       List<User> nList = List.generate(
  //           converted.length,
  //           (index) => User.fromJson(
  //                 converted[index],
  //               ));
  //       // set the value of 'categories' to 'nList'
  //       for (var user in nList) {
  //         ids.add(user.id);
  //       }
  //       // return the '_categories'
  //       return ids;
  //     });
  //   });

  //   // return await db.transaction((txn) async {
  //   //   return await txn.query(userTable, columns: ['id']).then((data) {
  //   //     final ids = [];
  //   //     final converted = List<Map<String, dynamic>>.from(data);

  //   //     // create a 'users'from every 'map' in this 'converted'
  //   //     List<User> nList = List.generate(
  //   //         converted.length,
  //   //         (index) => User.fromJson(
  //   //               converted[index],
  //   //             ));

  //   //     _users = nList;

  //   //     for (var user in _users) {
  //   //       ids.add(user.id);
  //   //       // List<int> genreIds = List<int>.from(user.id);
  //   //       // List<int> ids = List.castFrom<dynamic, int>(user.id);
  //   //       // List<int> ids = user.id.cast<int>();
  //   //       List<int> ids = user!.id.map((e) => e as int).toList();
  //   //     }

  //   //     _userIds = ids;

  //   //     return _userIds;
  //   //   });
  //   // });

  //   // var sql = """
  //   //           SELECT id FROM users;
  //   //           """;

  //   // return await db.transaction(((txn) {
  //   //   return txn.rawQuery(sql);
  //   // }));
  // }
}
