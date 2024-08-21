import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app_udevs/data/models/event_model.dart';
import 'package:todo_app_udevs/data/datasources/event_local_datasource.dart';

class EventLocalDataSourceImpl implements EventLocalDataSource {
  static final EventLocalDataSourceImpl _instance =
      EventLocalDataSourceImpl._init();
  static Database? _database;

  EventLocalDataSourceImpl._init();

  factory EventLocalDataSourceImpl() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        location TEXT,
        time TEXT,
        color TEXT,
        dateTime TEXT,
        endTime TEXT
      )
    ''');
  }

  @override
  Future<void> insertEvent(EventModel event) async {
    final db = await database;
    await db.insert('events', event.toMap());
  }

  @override
  Future<List<EventModel>> getEvents() async {
    final db = await database;
    final result = await db.query('events');
    return result.map((json) => EventModel.fromMap(json)).toList();
  }

  @override
  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    final db = await database;
    await db.update('events', event.toMap(),
        where: 'id = ?', whereArgs: [event.id]);
  }
}
