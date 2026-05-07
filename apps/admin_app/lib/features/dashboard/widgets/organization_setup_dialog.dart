import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizationSetupDialog extends StatefulWidget {
  final AdminRepository repository;
  final VoidCallback onSetupComplete;

  const OrganizationSetupDialog({
    super.key,
    required this.repository,
    required this.onSetupComplete,
  });

  @override
  State<OrganizationSetupDialog> createState() => _OrganizationSetupDialogState();
}

class _OrganizationSetupDialogState extends State<OrganizationSetupDialog> {
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _setup() async {
    if (_nameController.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.repository.createOrganization(_nameController.text);
      widget.onSetupComplete();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.business_rounded, color: AppColors.primary, size: 40.sp),
            ),
            SizedBox(height: 24.h),
            Text('Welcome to Arlith LMS', style: AppTextStyles.h2),
            SizedBox(height: 12.h),
            Text(
              'To get started, please create your organization workspace. This will unlock all administrative features.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyM,
            ),
            SizedBox(height: 32.h),
            AppTextField(
              controller: _nameController,
              label: 'Organization Name',
              hint: 'e.g. Arlith Academy',
              prefixIcon: const Icon(Icons.edit_rounded),
            ),
            if (_error != null) ...[
              SizedBox(height: 16.h),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 32.h),
            AppButton(
              text: 'Create Workspace',
              isLoading: _isLoading,
              onPressed: _setup,
            ),
          ],
        ),
      ),
    );
  }
}
