import 'package:flutter/material.dart';
import '../models/reminder.dart';
import 'add_reminder_screen.dart';
import 'edit_reminder_screen.dart';
import 'calendar_screen.dart';
import 'notification_settings_screen.dart';
import '../widgets/reminder_card.dart';
import 'services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  CropType? selectedCrop;
  List<Reminder> reminders = [];
  bool _loading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Selected section (0 = Pending, 1 = Overdue, 2 = Completed)
  int _selectedSection = 0;

  @override
  void initState() {
    super.initState();
    _loadReminders();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    setState(() => _loading = true);
    final data = await ApiService.getReminders();
    setState(() {
      reminders = data
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
      _loading = false;
    });
  }

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

  Future<void> _deleteReminder(Reminder r) async {
    final ok = await ApiService.deleteReminder(int.parse(r.id));
    if (ok) {
      setState(() => reminders.removeWhere((x) => x.id == r.id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Reminder deleted successfully'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  Future<void> _markAsCompleted(Reminder r) async {
    final ok = await ApiService.updateReminder(int.parse(r.id), {
      'title': r.reminderTypeString,
      'reminder_type': r.reminderType.name,
      'crop_type': r.cropTypeString,
      'field_name': r.fieldName,
      'date_time': r.dateTime.toIso8601String(),
      'is_completed': 1,
    });
    if (ok) {
      setState(() {
        final idx = reminders.indexWhere((x) => x.id == r.id);
        if (idx != -1) reminders[idx] = r.copyWith(isCompleted: true);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task completed! 🎉'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> _snoozeReminder(Reminder r) async {
    final newDateTime = r.dateTime.add(const Duration(hours: 1));
    final ok = await ApiService.updateReminder(int.parse(r.id), {
      'title': r.reminderTypeString,
      'reminder_type': r.reminderType.name,
      'crop_type': r.cropTypeString,
      'field_name': r.fieldName,
      'date_time': newDateTime.toIso8601String(),
      'is_completed': r.isCompleted ? 1 : 0,
    });
    if (ok) {
      setState(() {
        final idx = reminders.indexWhere((x) => x.id == r.id);
        if (idx != -1) reminders[idx] = r.copyWith(dateTime: newDateTime);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Snoozed for 1 hour ⏰'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> _editReminder(Reminder r) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditReminderScreen(
          initialReminder: r,
          onSave: (updated) async {
            await ApiService.updateReminder(
              int.parse(updated.id),
              {
                'title': updated.reminderTypeString,
                'reminder_type': updated.reminderType.name,
                'crop_type': updated.cropTypeString,
                'field_name': updated.fieldName,
                'date_time': updated.dateTime.toIso8601String(),
                'is_completed': updated.isCompleted ? 1 : 0,
              },
            );
            _loadReminders();
          },
        ),
      ),
    );
  }

  void _showReminderOptions(Reminder reminder) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reminder Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              if (!reminder.isCompleted)
                _buildOptionTile(
                  icon: Icons.check_circle_outline,
                  title: 'Mark as Complete',
                  subtitle: 'Mark this task as done',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _markAsCompleted(reminder);
                  },
                ),
              if (!reminder.isCompleted)
                _buildOptionTile(
                  icon: Icons.snooze,
                  title: 'Snooze',
                  subtitle: 'Remind me in 1 hour',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _snoozeReminder(reminder);
                  },
                ),
              _buildOptionTile(
                icon: Icons.edit_outlined,
                title: 'Edit Reminder',
                subtitle: 'Change details of this reminder',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _editReminder(reminder);
                },
              ),
              _buildOptionTile(
                icon: Icons.delete_outline,
                title: 'Delete Reminder',
                subtitle: 'Remove this reminder permanently',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(reminder);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Reminder'),
        content: Text(
            'Are you sure you want to delete "${reminder.reminderTypeString}" for ${reminder.fieldName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteReminder(reminder);
            },
            child: const Text('Delete',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  // ========== SEPARATE LISTS FOR EACH SECTION ==========
  List<Reminder> get _pendingTasks => reminders
      .where((r) => !r.isCompleted && r.dateTime.isAfter(DateTime.now()))
      .toList();

  List<Reminder> get _overdueTasks => reminders
      .where((r) => !r.isCompleted && r.dateTime.isBefore(DateTime.now()))
      .toList();

  List<Reminder> get _completedTasks =>
      reminders.where((r) => r.isCompleted).toList();

  // Combined filtered list based on selected section + crop filter
  List<Reminder> get _filteredTasks {
    List<Reminder> sourceTasks;

    switch (_selectedSection) {
      case 0:
        sourceTasks = _pendingTasks;
        break;
      case 1:
        sourceTasks = _overdueTasks;
        break;
      case 2:
        sourceTasks = _completedTasks;
        break;
      default:
        sourceTasks = reminders;
    }

    if (selectedCrop == null) {
      return sourceTasks;
    } else {
      return sourceTasks.where((r) => r.cropType == selectedCrop).toList();
    }
  }

  // Counts for each section
  int get _pendingCount => _pendingTasks.length;
  int get _overdueCount => _overdueTasks.length;
  int get _completedCount => _completedTasks.length;
  int get _totalCount => reminders.length;
  int get _completionRate => reminders.isEmpty
      ? 0
      : (_completedCount / reminders.length * 100).round();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _loading
              ? _buildLoadingState()
              : RefreshIndicator(
                  onRefresh: _loadReminders,
                  color: const Color(0xFF4CAF50),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildModernHeader(),

                      // ONLY ONE SET OF TABS (shows counts)
                      _buildSectionTabs(),

                      _buildSmartFilterBar(),

                      if (_filteredTasks.isEmpty)
                        _buildEmptyStateForSection()
                      else
                        _buildModernRemindersList(),
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: _buildPremiumFAB(),
    );
  }

  // ========== SECTION TABS (Shows Pending, Overdue, Completed with counts) ==========
  Widget _buildSectionTabs() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildTabButton(
                title: 'Pending',
                count: _pendingCount,
                icon: Icons.pending_actions,
                color: Colors.orange,
                isSelected: _selectedSection == 0,
                onTap: () => setState(() => _selectedSection = 0),
              ),
              _buildTabButton(
                title: 'Overdue',
                count: _overdueCount,
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
                isSelected: _selectedSection == 1,
                onTap: () => setState(() => _selectedSection = 1),
              ),
              _buildTabButton(
                title: 'Completed',
                count: _completedCount,
                icon: Icons.check_circle_outline,
                color: Colors.green,
                isSelected: _selectedSection == 2,
                onTap: () => setState(() => _selectedSection = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border(bottom: BorderSide(color: color, width: 3))
                : null,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: isSelected ? color : Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? color : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? color : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== EMPTY STATE FOR EACH SECTION ==========
  Widget _buildEmptyStateForSection() {
    String message;
    String suggestion;

    switch (_selectedSection) {
      case 0:
        message = 'No Pending Tasks';
        suggestion = 'All caught up! Add new reminders to stay organized.';
        break;
      case 1:
        message = 'No Overdue Tasks';
        suggestion = 'Great! You\'re on top of your schedule.';
        break;
      case 2:
        message = 'No Completed Tasks';
        suggestion = 'Complete some tasks to see them here.';
        break;
      default:
        message = 'No Tasks';
        suggestion = 'Add your first reminder';
    }

    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _getSectionColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getSectionIcon(),
                size: 50,
                color: _getSectionColor(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _getSectionColor(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              suggestion,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            if (_selectedSection != 2) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddReminderScreen()),
                  );
                  _loadReminders();
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Reminder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSectionColor() {
    switch (_selectedSection) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getSectionIcon() {
    switch (_selectedSection) {
      case 0:
        return Icons.pending_actions;
      case 1:
        return Icons.warning_amber_rounded;
      case 2:
        return Icons.check_circle_outline;
      default:
        return Icons.notifications_none;
    }
  }

  // ========== LOADING STATE ==========
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Loading Your Farm Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we fetch your reminders',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ========== HEADER SECTION ==========
  Widget _buildModernHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF4CAF50), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 0,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Farm Manager',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Farmer',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Completion Rate',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$_completionRate%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _completionRate / 100,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: Colors.white,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.white.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildHeaderStat('Total', _totalCount),
                            _buildHeaderStat('Active', _pendingCount),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildHeaderButton(Icons.notifications_outlined, 'Alerts', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationSettingsScreen(),
                    ),
                  );
                }),
                const SizedBox(width: 12),
                _buildHeaderButton(Icons.calendar_month_outlined, 'Calendar',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CalendarScreen(reminders: reminders),
                    ),
                  );
                }),
                const SizedBox(width: 12),
                _buildHeaderButton(
                    Icons.refresh_rounded, 'Sync', _loadReminders),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== FILTER BAR ==========
  Widget _buildSmartFilterBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Crop',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGlassFilterChip('All Crops', null, Icons.apps),
                  const SizedBox(width: 12),
                  _buildGlassFilterChip(
                      '🌾 Paddy', CropType.paddy, Icons.grass),
                  const SizedBox(width: 12),
                  _buildGlassFilterChip('🌽 Corn', CropType.corn, Icons.eco),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassFilterChip(String label, CropType? crop, IconData icon) {
    final selected = selectedCrop == crop;
    return GestureDetector(
      onTap: () => setState(() => selectedCrop = crop),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== REMINDERS LIST ==========
  Widget _buildModernRemindersList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final r = _filteredTasks[i];
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (i * 50)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Dismissible(
                      key: Key(r.id),
                      direction: _selectedSection == 2
                          ? DismissDirection.none
                          : DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.redAccent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete_rounded,
                            color: Colors.white, size: 32),
                      ),
                      onDismissed: (_) => _deleteReminder(r),
                      child: GestureDetector(
                        onTap: () => _showReminderOptions(r),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ReminderCard(
                            reminder: r,
                            onTap: () => _showReminderOptions(r),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          childCount: _filteredTasks.length,
        ),
      ),
    );
  }

  // ========== FLOATING ACTION BUTTON ==========
  Widget _buildPremiumFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddReminderScreen()),
        );
        _loadReminders();
      },
      backgroundColor: const Color(0xFF4CAF50),
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      icon: const Icon(Icons.add_circle_outline, size: 28),
      label: const Text(
        'Add Reminder',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    );
  }
}
