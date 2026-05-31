import 'package:flutter/material.dart';
import '../models/reminder.dart';

class EditReminderScreen extends StatefulWidget {
  final Reminder initialReminder;
  final Function(Reminder) onSave;

  const EditReminderScreen({
    super.key,
    required this.initialReminder,
    required this.onSave,
  });

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  late TextEditingController _fieldNameController;
  late TextEditingController _notesController;
  late CropType _selectedCrop;
  late ReminderType _selectedReminder;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _fieldNameController =
        TextEditingController(text: widget.initialReminder.fieldName);
    _notesController =
        TextEditingController(text: widget.initialReminder.notes ?? '');
    _selectedCrop = widget.initialReminder.cropType;
    _selectedReminder = widget.initialReminder.reminderType;
    _selectedDate = widget.initialReminder.dateTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.initialReminder.dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
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
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() {
    if (_fieldNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter field name')),
      );
      return;
    }

    final updatedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final updatedReminder = Reminder(
      id: widget.initialReminder.id,
      fieldName: _fieldNameController.text,
      cropType: _selectedCrop,
      reminderType: _selectedReminder,
      dateTime: updatedDateTime,
      repeatInterval: widget.initialReminder.repeatInterval,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      isCompleted: widget.initialReminder.isCompleted,
    );

    widget.onSave(updatedReminder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Reminder',
          style: TextStyle(color: Color(0xFF2E7D32)),
        ),
        actions: [
          TextButton(
            onPressed: _saveReminder,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit farming task',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Update the details below',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // Field Name
            const Text(
              'Field Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _fieldNameController,
              decoration: const InputDecoration(
                hintText: 'e.g., North Paddy Field, Field A',
              ),
            ),
            const SizedBox(height: 20),

            // Crop Type
            const Text(
              'Crop Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<CropType>(
                    title: const Text('Paddy'),
                    value: CropType.paddy,
                    groupValue: _selectedCrop,
                    onChanged: (value) {
                      setState(() {
                        _selectedCrop = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<CropType>(
                    title: const Text('Corn'),
                    value: CropType.corn,
                    groupValue: _selectedCrop,
                    onChanged: (value) {
                      setState(() {
                        _selectedCrop = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reminder Type
            const Text(
              'Reminder Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildReminderTypeTile(
                  ReminderType.sowing,
                  'Sowing',
                  'Plant seeds in the field',
                  Icons.agriculture,
                  Colors.blue,
                ),
                _buildReminderTypeTile(
                  ReminderType.irrigation,
                  'Irrigation',
                  'Water the crops',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildReminderTypeTile(
                  ReminderType.fertilizing,
                  'Fertilizing',
                  'Apply fertilizer',
                  Icons.eco,
                  Colors.orange,
                ),
                _buildReminderTypeTile(
                  ReminderType.harvesting,
                  'Harvesting',
                  'Harvest the crops',
                  Icons.grass,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date and Time
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.access_time, size: 18),
                    label: Text(_selectedTime.format(context)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Notes
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any additional notes...',
              ),
            ),

            // Status
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Completed'),
              value: widget.initialReminder.isCompleted,
              onChanged: null, // Read-only in edit screen
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTypeTile(
    ReminderType type,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedReminder == type;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? color.withOpacity(0.1) : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? color : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? color : Colors.black87,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: isSelected ? color.withOpacity(0.8) : Colors.grey,
          ),
        ),
        trailing: Radio<ReminderType>(
          value: type,
          groupValue: _selectedReminder,
          onChanged: (value) {
            setState(() {
              _selectedReminder = value!;
            });
          },
          activeColor: color,
        ),
        onTap: () {
          setState(() {
            _selectedReminder = type;
          });
        },
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
