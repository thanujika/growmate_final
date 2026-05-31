import 'package:flutter/material.dart';
import '../models/reminder.dart';

class CalendarScreen extends StatefulWidget {
  final List<Reminder> reminders;

  const CalendarScreen({super.key, required this.reminders});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();

  List<Reminder> getRemindersForDay(DateTime day) {
    return widget.reminders.where((reminder) {
      return reminder.dateTime.year == day.year &&
          reminder.dateTime.month == day.month &&
          reminder.dateTime.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calendar',
          style: TextStyle(color: Color(0xFF2E7D32)),
        ),
      ),
      body: Column(
        children: [
          // Month Selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                        1,
                      );
                    });
                  },
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                        1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // Weekday Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                _WeekdayCell('SUN'),
                _WeekdayCell('MON'),
                _WeekdayCell('TUE'),
                _WeekdayCell('WED'),
                _WeekdayCell('THU'),
                _WeekdayCell('FRI'),
                _WeekdayCell('SAT'),
              ],
            ),
          ),

          // Calendar Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: 42,
                itemBuilder: (context, index) {
                  final dayOffset = index - firstWeekday + 1;
                  if (dayOffset < 1 || dayOffset > daysInMonth) {
                    return Container();
                  }

                  final currentDay = DateTime(
                    _currentMonth.year,
                    _currentMonth.month,
                    dayOffset,
                  );
                  final dayReminders = getRemindersForDay(currentDay);
                  final isToday = currentDay.day == DateTime.now().day &&
                      currentDay.month == DateTime.now().month &&
                      currentDay.year == DateTime.now().year;

                  return _CalendarDayCell(
                    day: dayOffset,
                    reminders: dayReminders,
                    isToday: isToday,
                    onTap: () {
                      if (dayReminders.isNotEmpty) {
                        _showDayReminders(context, currentDay, dayReminders);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDayReminders(
    BuildContext context,
    DateTime day,
    List<Reminder> reminders,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${day.day} ${_getMonthName(day.month)} ${day.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...reminders.map((reminder) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(reminder.reminderTypeString),
                    subtitle: Text(reminder.fieldName),
                    trailing: Text(reminder.formattedTime),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

class _WeekdayCell extends StatelessWidget {
  final String text;

  const _WeekdayCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final int day;
  final List<Reminder> reminders;
  final bool isToday;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.day,
    required this.reminders,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: isToday ? const Color(0xFF4CAF50) : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isToday ? const Color(0xFF4CAF50) : Colors.black87,
              ),
            ),
            if (reminders.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

