import 'package:flutter/material.dart';
import '../models/reminder.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onTap;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
  });

  Color _getReminderColor(ReminderType type) {
    switch (type) {
      case ReminderType.sowing:
        return const Color(0xFF2196F3);
      case ReminderType.irrigation:
        return const Color(0xFF03A9F4);
      case ReminderType.fertilizing:
        return const Color(0xFFFF9800);
      case ReminderType.harvesting:
        return const Color(0xFF4CAF50);
    }
  }

  Color _getCropColor(CropType type) {
    switch (type) {
      case CropType.paddy:
        return const Color(0xFF2196F3);
      case CropType.corn:
        return const Color(0xFFFF9800);
    }
  }

  IconData _getReminderIcon(ReminderType type) {
    switch (type) {
      case ReminderType.sowing:
        return Icons.agriculture;
      case ReminderType.irrigation:
        return Icons.water_drop;
      case ReminderType.fertilizing:
        return Icons.eco;
      case ReminderType.harvesting:
        return Icons.grass;
    }
  }

  Color _getTimeColor(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reminderDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (reminderDay.isBefore(today)) {
      return Colors.red;
    } else if (reminderDay == today) {
      return Colors.blue;
    } else if (reminderDay == today.add(const Duration(days: 1))) {
      return Colors.orange;
    } else {
      return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminderColor = _getReminderColor(reminder.reminderType);
    final cropColor = _getCropColor(reminder.cropType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Section
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    reminderColor,
                    reminderColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getReminderIcon(reminder.reminderType),
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),

            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reminder.reminderTypeString,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Crop Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: cropColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              reminder.cropType == CropType.paddy
                                  ? Icons.grass
                                  : Icons.eco,
                              size: 12,
                              color: cropColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              reminder.cropTypeString,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: cropColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Field Name
                  Text(
                    reminder.fieldName,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Date/Time + Completed Status Row
                  Row(
                    children: [
                      // Date & Time Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _getTimeColor(reminder.dateTime).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: _getTimeColor(reminder.dateTime),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${reminder.formattedDate} • ${reminder.formattedTime}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _getTimeColor(reminder.dateTime),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Completed Badge
                      if (reminder.isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Pending Status Dot
            if (!reminder.isCompleted)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: reminder.dateTime.isBefore(DateTime.now())
                      ? Colors.red
                      : Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (reminder.dateTime.isBefore(DateTime.now())
                              ? Colors.red
                              : Colors.orange)
                          .withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
