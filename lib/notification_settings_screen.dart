import 'package:flutter/material.dart';
import 'package:agri_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';
import 'services/api_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();

  // Settings
  bool _enableNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  int _advanceTime = 15;

  // Notification History - Real reminders only
  List<Map<String, dynamic>> _notificationHistory = [];
  bool _loadingHistory = true;

  // Reminders data
  List<Reminder> _reminders = [];
  bool _loadingReminders = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadRemindersAndHistory();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Load reminders from API and generate history
  Future<void> _loadRemindersAndHistory() async {
    setState(() => _loadingHistory = true);

    try {
      // Fetch reminders from your API
      final data = await ApiService.getReminders();
      _reminders = data
          .map((r) => Reminder(
                id: r['id'].toString(),
                fieldName: r['field_name'] ?? '',
                cropType:
                    r['crop_type'] == 'Corn' ? CropType.corn : CropType.paddy,
                reminderType: _parseReminderType(r['reminder_type']),
                dateTime: DateTime.parse(r['date_time']),
                notes: r['notes'],
                isCompleted: (r['is_completed'] ?? 0) == 1,
              ))
          .toList();

      // Generate notification history from reminders
      _generateHistoryFromReminders();
    } catch (e) {
      print('Error loading reminders: $e');
      _notificationHistory = [];
    } finally {
      setState(() {
        _loadingHistory = false;
        _loadingReminders = false;
      });
    }
  }

  // Parse reminder type from string
  ReminderType _parseReminderType(String? t) {
    switch (t) {
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

  // Generate history from completed and overdue reminders
  void _generateHistoryFromReminders() {
    final List<Map<String, dynamic>> history = [];
    final now = DateTime.now();

    for (final reminder in _reminders) {
      bool shouldAdd = false;
      String statusMessage = '';
      Color statusColor = Colors.grey;
      IconData statusIcon = Icons.notifications;

      // Check if reminder is COMPLETED
      if (reminder.isCompleted) {
        shouldAdd = true;
        statusMessage = 'Completed';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
      }
      // Check if reminder is OVERDUE (not completed AND date passed)
      else if (reminder.dateTime.isBefore(now)) {
        shouldAdd = true;
        statusMessage = 'Overdue';
        statusColor = Colors.red;
        statusIcon = Icons.warning_amber_rounded;
      }

      if (shouldAdd) {
        history.add({
          'id': reminder.id,
          'title': '${reminder.reminderTypeString} Reminder',
          'message':
              '$statusMessage: ${reminder.reminderTypeString} for ${reminder.fieldName}',
          'time': reminder.dateTime,
          'read': false,
          'type': 'reminder',
          'icon': _getReminderIcon(reminder.reminderType),
          'color': _getReminderColor(reminder.reminderType),
          'status': statusMessage,
          'statusColor': statusColor,
          'statusIcon': statusIcon,
          'fieldName': reminder.fieldName,
          'cropType': reminder.cropTypeString,
          'reminderId': reminder.id,
        });
      }
    }

    // Sort by time (newest first)
    history.sort((a, b) => b['time'].compareTo(a['time']));

    _notificationHistory = history;
  }

  // Get icon for reminder type
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

  // Get color for reminder type
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

  // Refresh history (call this when returning to screen)
  void _refreshHistory() {
    _loadRemindersAndHistory();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableNotifications = prefs.getBool('enable_notifications') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _advanceTime = prefs.getInt('advance_time') ?? 15;
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  // Mark notification as read
  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['read'] = true;
    });
    _showSnackbar('Marked as read');
  }

  // Clear all notifications (just clears history view, doesn't delete reminders)
  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear History'),
        content: const Text(
            'This will only clear the notification history view. Your reminders will NOT be deleted. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notificationHistory.clear();
              });
              Navigator.pop(context);
              _showSnackbar('History cleared');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // Send test notification
  Future<void> _sendTestNotification() async {
    if (!_enableNotifications) {
      _showSnackbar('Please enable notifications first');
      return;
    }

    await _notificationService.showTestNotification();
    _showSnackbar('Test notification sent!');
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 7) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Reminder History',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4CAF50)),
            onPressed: _refreshHistory,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.checklist, color: Color(0xFF4CAF50)),
            onPressed: () {
              setState(() {
                for (var notification in _notificationHistory) {
                  notification['read'] = true;
                }
              });
              _showSnackbar('All marked as read');
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              // Tab Bar
              Container(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: const Color(0xFF4CAF50),
                  labelColor: const Color(0xFF4CAF50),
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Settings'),
                    Tab(text: 'History'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Settings Tab
                    _buildSettingsTab(),

                    // History Tab - Real reminders only
                    _buildHistoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        // Header Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Push Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Get alerts about your farming tasks',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _enableNotifications,
                onChanged: (value) {
                  setState(() {
                    _enableNotifications = value;
                    _saveSettings('enable_notifications', value);
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.green.shade300,
              ),
            ],
          ),
        ),

        // Notification Settings Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.volume_up,
                title: 'Sound',
                subtitle: 'Play sound for notifications',
                enabled: _enableNotifications,
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                    _saveSettings('sound_enabled', value);
                  });
                },
              ),
              const Divider(height: 1, indent: 70),
              _buildSettingsItem(
                icon: Icons.vibration,
                title: 'Vibration',
                subtitle: 'Vibrate for notifications',
                enabled: _enableNotifications,
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    _vibrationEnabled = value;
                    _saveSettings('vibration_enabled', value);
                  });
                },
              ),
              const Divider(height: 1, indent: 70),
              _buildAdvanceTimeSetting(),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Action Buttons Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActionItem(
                icon: Icons.notification_add,
                title: 'Test Notification',
                subtitle: 'Send a test notification',
                color: const Color(0xFF4CAF50),
                onTap: _sendTestNotification,
                enabled: _enableNotifications,
              ),
              const Divider(height: 1, indent: 70),
              _buildActionItem(
                icon: Icons.delete_sweep,
                title: 'Clear History',
                subtitle: 'Clear notification history view',
                color: Colors.red,
                onTap: _clearAllNotifications,
                enabled: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Info Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'History shows reminders that are COMPLETED or OVERDUE.\nRefresh to update from your reminders.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvanceTimeSetting() {
    final advanceTimes = [
      {'minutes': 5, 'label': '5 minutes before'},
      {'minutes': 15, 'label': '15 minutes before'},
      {'minutes': 30, 'label': '30 minutes before'},
      {'minutes': 60, 'label': '1 hour before'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.timer, color: Color(0xFFFF9800), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reminder Timing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Notify me before task',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<int>(
            value: _advanceTime,
            items: advanceTimes.map((item) {
              return DropdownMenuItem<int>(
                value: item['minutes'] as int,
                child: Text(item['label'] as String),
              );
            }).toList(),
            onChanged: _enableNotifications
                ? (value) {
                    setState(() {
                      _advanceTime = value!;
                      _saveSettings('advance_time', value);
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: enabled ? onTap : null,
    );
  }

  Widget _buildHistoryTab() {
    if (_loadingHistory) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
      );
    }

    if (_notificationHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 50,
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No History Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completed or overdue reminders will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshHistory,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notificationHistory.length,
      itemBuilder: (context, index) {
        final notification = _notificationHistory[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;
    final time = notification['time'] as DateTime;
    final color = notification['color'] as Color;
    final status = notification['status'] as String;
    final statusColor = notification['statusColor'] as Color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _markAsRead(notification),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    notification['icon'] as IconData,
                    color: color,
                    size: 26,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isRead ? FontWeight.w600 : FontWeight.w700,
                          color: isRead ? Colors.grey.shade700 : Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            notification['statusIcon'] as IconData,
                            size: 12,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      notification['message'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: isRead
                            ? Colors.grey.shade600
                            : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification['fieldName'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(time),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            notification['cropType'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: notification['cropType'] == 'Paddy'
                                  ? Colors.blue.shade700
                                  : Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade400),
                  onSelected: (value) {
                    if (value == 'delete') {
                      setState(() {
                        _notificationHistory.remove(notification);
                      });
                      _showSnackbar('Removed from history');
                    } else if (value == 'mark_read') {
                      _markAsRead(notification);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.mark_chat_read_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Mark as read'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Remove from history',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isRead)
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
