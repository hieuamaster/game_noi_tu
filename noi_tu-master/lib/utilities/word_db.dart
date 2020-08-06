import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import '../utilities/words.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openDB() async {
  // Construct the path to the app's writable database file:
  var dbDir = await getDatabasesPath();
  var dbPath = join(dbDir, "app.db");

// Delete any existing database:
  // await deleteDatabase(dbPath);

// Create the writable database file from the bundled demo database file:
  ByteData data = await rootBundle.load("assets/words.db");
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(dbPath).writeAsBytes(bytes);

  final database = openDatabase(dbPath);
  return database;
}

Future<List<Word>> findRandomWord(final database, String tail) async {
  // Get a reference to the database.
  final Database db = await database;
  List<Map<String, dynamic>> maps;
  // Query the table for all The Dogs.
  if (tail == null || tail == "")
    maps = await db.rawQuery(
        'SELECT * FROM words WHERE count > 1 ORDER BY RANDOM() LIMIT 1;');
  else
    maps = await db.rawQuery(
        'SELECT * FROM words WHERE head = "$tail" AND count > 1 ORDER BY RANDOM() LIMIT 1;');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Word(
      text: maps[i]['text'],
      chuan: maps[i]['chuan'],
      head: maps[i]['head'],
      tail: maps[i]['tail'],
    );
  });
}

Future<bool> checkWord(final database, String word) async {
  // Get a reference to the database.
  final Database db = await database;
  List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM words WHERE text = "$word" ORDER BY RANDOM() LIMIT 1;');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return maps.length > 0;
}
