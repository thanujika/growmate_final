import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/reminder.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'growmate.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        field_name TEXT NOT NULL,
        crop_type TEXT NOT NULL,
        reminder_type TEXT NOT NULL,
        date_time TEXT NOT NULL,
        notes TEXT,
        is_completed INTEGER DEFAULT 0,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        time TEXT NOT NULL,
        read INTEGER DEFAULT 0,
        type TEXT NOT NULL,
        reminder_id TEXT
      )
    ''');
  }

  // ========== REMINDER OPERATIONS ==========

  Future<void> insertReminder(Reminder reminder) async {
    final db = await database;
    await db.insert(
        'reminders',
        {
          'id': reminder.id,
          'field_name': reminder.fieldName,
          'crop_type': reminder.cropTypeString,
          'reminder_type': reminder.reminderTypeString,
          'date_time': reminder.dateTime.toIso8601String(),
          'notes': reminder.notes ?? '',
          'is_completed': reminder.isCompleted ? 1 : 0,
          'synced': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');

    return maps
        .map((map) => Reminder(
              id: map['id'],
              fieldName: map['field_name'],
              cropType:
                  map['crop_type'] == 'Paddy' ? CropType.paddy : CropType.corn,
              reminderType: _parseReminderType(map['reminder_type']),
              dateTime: DateTime.parse(map['date_time']),
              notes: map['notes'],
              isCompleted: map['is_completed'] == 1,
            ))
        .toList();
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
          'notes': reminder.notes ?? '',
          'is_completed': reminder.isCompleted ? 1 : 0,
          'synced': 0,
        },
        where: 'id = ?',
        whereArgs: [reminder.id]);
  }

  Future<void> deleteReminder(String id) async {
    final db = await database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markSynced(String id) async {
    final db = await database;
    await db.update('reminders', {'synced': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Reminder>> getUnsyncedReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reminders',
      where: 'synced = 0',
    );

    return maps
        .map((map) => Reminder(
              id: map['id'],
              fieldName: map['field_name'],
              cropType:
                  map['crop_type'] == 'Paddy' ? CropType.paddy : CropType.corn,
              reminderType: _parseReminderType(map['reminder_type']),
              dateTime: DateTime.parse(map['date_time']),
              notes: map['notes'],
              isCompleted: map['is_completed'] == 1,
            ))
        .toList();
  }

  // ========== NOTIFICATION OPERATIONS ==========

  Future<void> insertNotification(Map<String, dynamic> notification) async {
    final db = await database;
    await db.insert(
        'notifications',
        {
          'id': notification['id'],
          'title': notification['title'],
          'message': notification['message'],
          'time': (notification['time'] as DateTime).toIso8601String(),
          'read': notification['read'] ? 1 : 0,
          'type': notification['type'],
          'reminder_id': notification['reminderId'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      orderBy: 'time DESC',
    );

    return maps
        .map((map) => {
              'id': map['id'],
              'title': map['title'],
              'message': map['message'],
              'time': DateTime.parse(map['time']),
              'read': map['read'] == 1,
              'type': map['type'],
              'reminderId': map['reminder_id'],
            })
        .toList();
  }

  Future<void> markNotificationRead(String id) async {
    final db = await database;
    await db.update('notifications', {'read': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNotification(String id) async {
    final db = await database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  ReminderType _parseReminderType(String type) {
    switch (type) {
      case 'Sowing':
        return ReminderType.sowing;
      case 'Fertilizing':
        return ReminderType.fertilizing;
      case 'Harvesting':
        return ReminderType.harvesting;
      default:
        return ReminderType.irrigation;
    }
  }
}
