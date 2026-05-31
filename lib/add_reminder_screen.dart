// ignore_for_file: equal_keys_in_map

import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../services/notification_service.dart';
import 'services/api_service.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fieldNameController = TextEditingController();
  final _notesController = TextEditingController();
  CropType _selectedCrop = CropType.corn;
  ReminderType _selectedReminder = ReminderType.irrigation;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  RepeatInterval _repeatInterval = RepeatInterval.none;
  final NotificationService _notificationService = NotificationService();
  bool _isSubmitting = false;

  final Map<ReminderType, Map<String, dynamic>> _reminderTypes = {
    ReminderType.sowing: {
      'title': 'Sowing',
      'description': 'Plant seeds in the field',
      'icon': Icons.agriculture,
      'color': const Color(0xFF2196F3),
      'gradient': [const Color(0xFF2196F3), const Color(0xFF21CBF3)],
    },
    ReminderType.irrigation: {
      'title': 'Irrigation',
      'description': 'Water the crops',
      'icon': Icons.water_drop,
      'color': const Color(0xFF00BCD4),
      'gradient': [const Color(0xFF00BCD4), const Color(0xFF00E5FF)],
    },
    ReminderType.fertilizing: {
      'title': 'Fertilizing',
      'description': 'Apply fertilizer',
      'icon': Icons.eco,

      'color': const Color(0xFFFF9800),
      'gradient': [const Color(0xFFFF9800), const Color(0xFFFFB74D)],

      // ignore: duplicate_ignore
      // ignore: equal_keys_in_map
      'color': Color(0xFFFF9800),
      'gradient': [Color(0xFFFF9800), Color(0xFFFFB74D)],
    },
    ReminderType.harvesting: {
      'title': 'Harvesting',
      'description': 'Harvest the crops',
      'icon': Icons.grass,
      'color': const Color(0xFF4CAF50),
      'gradient': [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
      'color': Color(0xFF4CAF50),
      'gradient': [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    },
  };

  final Map<RepeatInterval, String> _repeatLabels = {
    RepeatInterval.none: 'No Repeat',
    RepeatInterval.daily: 'Daily',
    RepeatInterval.weekly: 'Weekly',
    RepeatInterval.custom: 'Custom',
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final dt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Save to backend
    final ok = await ApiService.createReminder({
      'title': _selectedReminder.name,
      'reminder_type': _selectedReminder.name,
      'crop_type': _selectedCrop == CropType.paddy ? 'Paddy' : 'Corn',
      'field_name': _fieldNameController.text,
      'date_time': dt.toIso8601String(),
      'notes': _notesController.text,
    });

    setState(() => _isSubmitting = false);

    if (!mounted) return;
    if (ok) {
      // Also schedule local notification
      final reminder = Reminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fieldName: _fieldNameController.text,
        cropType: _selectedCrop,
        reminderType: _selectedReminder,
        dateTime: dt,
        repeatInterval: _repeatInterval,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      if (dt.isAfter(DateTime.now())) {
        _notificationService.scheduleReminderNotification(reminder);
      }
      Navigator.pop(context, reminder);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to save reminder. Check connection.'),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Reminder',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Schedule your farming task',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                          ),
                        )
                      : TextButton(
                          onPressed: _saveReminder,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF4CAF50),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field Name
                      _buildSectionHeader(
                        icon: Icons.location_on,
                        title: 'Field Information',
                        subtitle: 'Enter details about your field',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _fieldNameController,
                        decoration: InputDecoration(
                          hintText: 'e.g., North Paddy Field, Field A',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF4CAF50),
                              width: 2,
                            ),
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.agriculture,
                              color: Color(0xFF4CAF50),
                              size: 20,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter field name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Crop Type
                      _buildSectionHeader(
                        icon: Icons.spa,
                        title: 'Crop Type',
                        subtitle: 'Select the crop you are growing',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCropOption(
                              crop: CropType.paddy,
                              label: '🌾 Paddy',
                              description: 'Rice field',
                              isSelected: _selectedCrop == CropType.paddy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildCropOption(
                              crop: CropType.corn,
                              label: '🌽 Corn',
                              description: 'Maize field',
                              isSelected: _selectedCrop == CropType.corn,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Reminder Type
                      _buildSectionHeader(
                        icon: Icons.notifications,
                        title: 'Task Type',
                        subtitle: 'What do you need to do?',
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _reminderTypes.entries.map((entry) {
                          final type = entry.key;
                          final data = entry.value;
                          final isSelected = _selectedReminder == type;

                          return _buildReminderTypeCard(
                            type: type,
                            title: data['title'] as String,
                            description: data['description'] as String,
                            icon: data['icon'] as IconData,
                            color: data['color'] as Color,
                            gradient: data['gradient'] as List<Color>,
                            isSelected: isSelected,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Schedule
                      _buildSectionHeader(
                        icon: Icons.calendar_today,
                        title: 'Schedule',
                        subtitle: 'When should we remind you?',
                      ),
                      const SizedBox(height: 16),
                      Container(
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
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Date Selection
                              _buildDateTimeSelector(
                                icon: Icons.calendar_today,
                                label: 'Date',
                                value:
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                onTap: () => _selectDate(context),
                              ),
                              const SizedBox(height: 16),
                              // Time Selection
                              _buildDateTimeSelector(
                                icon: Icons.access_time,
                                label: 'Time',
                                value: _selectedTime.format(context),
                                onTap: () => _selectTime(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Repeat
                      _buildSectionHeader(
                        icon: Icons.repeat,
                        title: 'Repeat',
                        subtitle: 'How often should this repeat?',
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: _repeatLabels.entries.map((entry) {
                          final interval = entry.key;
                          final label = entry.value;
                          final isSelected = _repeatInterval == interval;

                          return ChoiceChip(
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _repeatInterval = interval;
                              });
                            },
                            selectedColor: const Color(0xFF4CAF50),
                            backgroundColor: Colors.grey.shade100,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Notes
                      _buildSectionHeader(
                        icon: Icons.note,
                        title: 'Additional Notes',
                        subtitle: 'Any special instructions? (Optional)',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Add any additional notes or special instructions...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF4CAF50),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Create Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _saveReminder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            shadowColor:
                                const Color(0xFF4CAF50).withOpacity(0.3),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Create Reminder',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4CAF50),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
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
          ],
        ),
      ],
    );
  }

  Widget _buildCropOption({
    required CropType crop,
    required String label,
    required String description,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCrop = crop;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? crop == CropType.paddy
                  ? Colors.blue.shade50
                  : Colors.orange.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? crop == CropType.paddy
                    ? Colors.blue.shade300
                    : Colors.orange.shade300
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? crop == CropType.paddy
                        ? Colors.blue.shade800
                        : Colors.orange.shade800
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? crop == CropType.paddy
                          ? Colors.blue.shade300
                          : Colors.orange.shade300
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: crop == CropType.paddy
                              ? Colors.blue.shade600
                              : Colors.orange.shade600,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTypeCard({
    required ReminderType type,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<Color> gradient,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReminder = type;
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 72) / 2,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.1 : 0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : color,
                  size: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey.shade600,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              if (isSelected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Selected',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelector({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4CAF50),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
