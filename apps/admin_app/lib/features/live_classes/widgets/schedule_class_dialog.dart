import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleClassDialog extends StatefulWidget {
  final AdminRepository repository;
  final VoidCallback onSuccess;

  const ScheduleClassDialog({
    super.key,
    required this.repository,
    required this.onSuccess,
  });

  @override
  State<ScheduleClassDialog> createState() => _ScheduleClassDialogState();
}

class _ScheduleClassDialogState extends State<ScheduleClassDialog> {
  final _titleController = TextEditingController();
  String? _selectedBatchId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;
  List<Batch> _batches = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    try {
      final batches = await widget.repository.getBatches();
      setState(() => _batches = batches);
    } catch (_) {}
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _selectedBatchId == null) {
      setState(() => _error = 'Title and Batch are required');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final startTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await widget.repository.createLiveClass(
        title: _titleController.text,
        batchId: _selectedBatchId!,
        startTime: startTime,
        endTime: startTime.add(const Duration(hours: 1)),
      );
      widget.onSuccess();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text('Schedule Live Class', style: AppTextStyles.h3),
      content: SizedBox(
        width: 450.w,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Class Title',
                hint: 'e.g. Introduction to Calculus',
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                value: _selectedBatchId,
                decoration: const InputDecoration(labelText: 'Select Batch'),
                items: _batches.map((b) => DropdownMenuItem(
                  value: b.id,
                  child: Text(b.name),
                )).toList(),
                onChanged: (val) => setState(() => _selectedBatchId = val),
              ),
              SizedBox(height: 16.h),
              ListTile(
                title: const Text('Select Date'),
                subtitle: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_month_rounded),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              ListTile(
                title: const Text('Select Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time_rounded),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null) setState(() => _selectedTime = picked);
                },
              ),
              if (_error != null) ...[
                SizedBox(height: 16.h),
                Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        AppButton(
          text: 'Schedule Now',
          isFullWidth: false,
          width: 160.w,
          isLoading: _isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
