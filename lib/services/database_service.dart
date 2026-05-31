import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reminder.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'growmate.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id TEXT,
        field_name TEXT NOT NULL,
        crop_type TEXT NOT NULL,
        reminder_type TEXT NOT NULL,
        date_time TEXT NOT NULL,
        notes TEXT,
        is_completed INTEGER DEFAULT 0,
        is_synced INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Notifications history table
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Sync queue table
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operation TEXT NOT NULL,
        table_name TEXT NOT NULL,
        record_id TEXT,
        data TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE reminders ADD COLUMN is_synced INTEGER DEFAULT 0');
    }
  }

  // ============ Reminder Operations ============

  Future<int> insertReminder(Reminder reminder, {bool isSynced = false}) async {
    final db = await database;
    return await db.insert('reminders', {
      'server_id': reminder.id,
      'field_name': reminder.fieldName,
      'crop_type': reminder.cropTypeString,
      'reminder_type': reminder.reminderTypeString,
      'date_time': reminder.dateTime.toIso8601String(),
      'notes': reminder.notes,
      'is_completed': reminder.isCompleted ? 1 : 0,
      'is_synced': isSynced ? 1 : 0,
    });
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reminders',
      orderBy: 'date_time ASC',
    );

    return List.generate(maps.length, (i) {
      return Reminder(
        id: maps[i]['server_id']?.toString() ?? maps[i]['id'].toString(),
        fieldName: maps[i]['field_name'],
        cropType:
            maps[i]['crop_type'] == 'Paddy' ? CropType.paddy : CropType.corn,
        reminderType: _parseReminderType(maps[i]['reminder_type']),
        dateTime: DateTime.parse(maps[i]['date_time']),
        notes: maps[i]['notes'],
        isCompleted: maps[i]['is_completed'] == 1,
      );
    });
  }

  Future<void> updateReminder(Reminder reminder) async {
    final db = await database;
    await db.update(
      'reminders',
      {
        'field_name': reminder.fieldName,
        'crop_type': reminder.cropTypeString,
        'reminder_type': reminder.reminderTypeString,
        'date_time': reminder.dateTime.toIso8601String(),
        'notes': reminder.notes,
        'is_completed': reminder.isCompleted ? 1 : 0,
        'is_synced': 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'server_id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<void> deleteReminder(String id) async {
    final db = await database;
    await db.delete('reminders', where: 'server_id = ?', whereArgs: [id]);
  }

  ReminderType _parseReminderType(String type) {
    switch (type.toLowerCase()) {
      case 'sowing':
        return ReminderType.sowing;
      case 'fertilizing':
        return ReminderType.fertilizing;
      case 'harvesting':
        return ReminderType.harvesting;
      default:
        return ReminderType.irrigation;
    }
  }

  // ============ Notification Operations ============

  Future<void> insertNotification(
      String title, String message, String type) async {
    final db = await database;
    await db.insert('notifications', {
      'title': title,
      'message': message,
      'type': type,
      'is_read': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db.query(
      'notifications',
      orderBy: 'created_at DESC',
    );
  }

  Future<void> markNotificationAsRead(int id) async {
    final db = await database;
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  // ============ Sync Queue Operations ============

  Future<void> addToSyncQueue(String operation, String tableName,
      String recordId, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('sync_queue', {
      'operation': operation,
      'table_name': tableName,
      'record_id': recordId,
      'data': data.toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final db = await database;
    return await db.query('sync_queue');
  }

  Future<void> removeFromSyncQueue(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }
}
