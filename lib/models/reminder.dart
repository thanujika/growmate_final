// lib/models/reminder.dart - CLEAN VERSION
enum CropType { paddy, corn }
enum ReminderType { sowing, irrigation, fertilizing, harvesting }
enum RepeatInterval { none, daily, weekly, custom }

class Reminder {
  String id;
  String fieldName;
  CropType cropType;
  ReminderType reminderType;
  DateTime dateTime;
  RepeatInterval repeatInterval;
  String? notes;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.fieldName,
    required this.cropType,
    required this.reminderType,
    required this.dateTime,
    this.repeatInterval = RepeatInterval.none,
    this.notes,
    this.isCompleted = false,
  });

  Reminder copyWith({
    String? id,
    String? fieldName,
    CropType? cropType,
    ReminderType? reminderType,
    DateTime? dateTime,
    RepeatInterval? repeatInterval,
    String? notes,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      fieldName: fieldName ?? this.fieldName,
      cropType: cropType ?? this.cropType,
      reminderType: reminderType ?? this.reminderType,
      dateTime: dateTime ?? this.dateTime,
      repeatInterval: repeatInterval ?? this.repeatInterval,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  String get cropTypeString {
    switch (cropType) {
      case CropType.paddy:
        return 'Paddy';
      case CropType.corn:
        return 'Corn';
    }
  }

  String get reminderTypeString {
    switch (reminderType) {
      case ReminderType.sowing:
        return 'Sowing';
      case ReminderType.irrigation:
        return 'Irrigation';
      case ReminderType.fertilizing:
        return 'Fertilizing';
      case ReminderType.harvesting:
        return 'Harvesting';
    }
  }

  String get formattedTime {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reminderDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (reminderDay == today) {
      return 'Today';
    } else if (reminderDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (reminderDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}