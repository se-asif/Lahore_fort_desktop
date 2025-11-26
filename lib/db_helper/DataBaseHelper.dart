import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ffi' as ffi; // Import the dart:ffi library
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

import '../data_models/visiting_data_list/visiting_data_list.dart';
import '../utils/log.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern to ensure only one instance of the database
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  final ValueNotifier<int> visitCountNotifier = ValueNotifier<int>(0);

  Future<void> _fetchVisitCount() async {
      final data = await getVisitingData();
      visitCountNotifier.value = data.length; // Update the notifier
    }
  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    PrintLog.printLog("_initDatabase ..... ");
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final dbPath = join(
          appDocumentsDir.path, "databases", "lahore_fort_live.db");

         print("Database path: $dbPath");
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: _onCreate,
        ),
      );
      return winLinuxDB;
    }
    throw Exception("Unsupported platform");
  }

  Future<void> _onCreate(Database db, int version) async {


    await db.execute('''
      CREATE TABLE visiting_data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          typeWiseData TEXT,
          paymentId TEXT,
          totalPersons TEXT,
          totalAmount TEXT,
          gateId TEXT,
          parkingLotId TEXT,
          userId TEXT,
          date TEXT,
          userName TEXT,
          gateName TEXT,
          ticketingPoint TEXT,
          transactionUniqueId TEXT,
          userMacId TEXT,
          isUploaded INTEGER, 
          billNo TEXT
      )      
    ''');
  }

  // Insert visiting data
  // Future<int> insertVisitingData(Map<String, dynamic> data) async {
  //   final db = await database;
  //   await _fetchVisitCount();
  //   return await db.insert("visiting_data", data);
  //
  //
  // }
  Future<int> insertVisitingData(VisitingDataList data) async {
      final db = await database;

      /// Convert object to a Map
      final dataMap = data.toJson();

      /// Ensure typeWiseData is stored as a JSON string
      dataMap['typeWiseData'] = jsonEncode(data.typeWiseData);

      /// Insert into SQLite
      int result = await db.insert("visiting_data", dataMap);

      _fetchVisitCount(); // Update visit count
      return result;
    }

  Future<int> updateIsUploaded(String id) async {
    final db = await database;
   // print("Updating record with transactionUniqueId: $id, isUploaded: "); // Debug log
    int result = await db.update(
      "visiting_data",
      {"isUploaded": 1},
      where: "transactionUniqueId = ?",
      whereArgs: [id],
    );

    //print("Update result: $result");
    _fetchVisitCount();
    return result;
  }


Future<List<VisitingDataList>> getVisitingData() async {
     final db = await database;
     final List<Map<String, dynamic>> maps = await db.query("visiting_data");

     //print("Raw data from DB: $maps"); // Debug print

     return maps.map((data) {
       final visitingData = VisitingDataList.fromJson({
         ...data,
         "typeWiseData": jsonDecode(data["typeWiseData"]), // Convert back to List
       });

       //print("Parsed VisitingDataList object: $visitingData"); // Debug print
       return visitingData;
     }).toList();
   }


  Future<List<VisitingDataList>> getPendingData() async {
    final db = await database;

    // Fetch records where isUploaded = 0
    final List<Map<String, dynamic>> maps = await db.query(
      "visiting_data",
      where: "isUploaded = ?",
      whereArgs: [0],
    );

    return maps.map((data) {
      final visitingData = VisitingDataList.fromJson({
        ...data,
        "typeWiseData": jsonDecode(data["typeWiseData"]), // Convert back to List
      });
      return visitingData;
    }).toList();
  }


  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS visiting_data");
    //PrintLog.printLog("Table dropped successfully.");

    _fetchVisitCount();
    await _onCreate(db, 1); // Ensure _onCreate properly recreates the table
    //PrintLog.printLog("Database reset successfully.");
  }


}
