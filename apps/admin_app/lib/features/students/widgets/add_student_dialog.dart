import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddStudentDialog extends StatefulWidget {
  final AdminRepository repository;
  final VoidCallback onSuccess;

  const AddStudentDialog({
    super.key,
    required this.repository,
    required this.onSuccess,
  });

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please fill all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.repository.createStudent(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
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
      title: Text('Add New Student', style: AppTextStyles.h3),
      content: SizedBox(
        width: 400.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter student name',
              prefixIcon: const Icon(Icons.person_rounded),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'Enter email address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_rounded),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _passwordController,
              label: 'Initial Password',
              hint: 'Enter temporary password',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_rounded),
            ),
            if (_error != null) ...[
              SizedBox(height: 16.h),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        AppButton(
          text: 'Save Student',
          isFullWidth: false,
          width: 150.w,
          isLoading: _isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
