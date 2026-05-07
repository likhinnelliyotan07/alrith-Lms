import 'package:admin_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhiteLabelSettingsView extends StatefulWidget {
  const WhiteLabelSettingsView({super.key});

  @override
  State<WhiteLabelSettingsView> createState() => _WhiteLabelSettingsViewState();
}

class _WhiteLabelSettingsViewState extends State<WhiteLabelSettingsView> {
  final _nameController = TextEditingController();
  Color _primaryColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Arlith LMS';
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBar: AppBar(title: Text('White Label Branding', style: AppTextStyles.h3)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Identity', style: AppTextStyles.h4),
            SizedBox(height: 24.h),
            NeumorphicContainer(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  AppTextField(
                    label: 'Application Name',
                    controller: _nameController,
                    hint: 'Enter your brand name',
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      _buildLogoPicker('App Logo', 'https://via.placeholder.com/150'),
                      SizedBox(width: 32.w),
                      _buildLogoPicker('Splash Screen Logo', 'https://via.placeholder.com/150'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Text('Color System', style: AppTextStyles.h4),
            SizedBox(height: 24.h),
            NeumorphicContainer(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Primary Brand Color'),
                    subtitle: Text(_primaryColor.toString()),
                    trailing: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Color picker logic
                    },
                  ),
                  const Divider(),
                  _buildThemeToggle(),
                ],
              ),
            ),
            SizedBox(height: 48.h),
            AppButton(
              text: 'Save Branding Configuration',
              onPressed: () {
                // Save to Supabase and WhiteLabelController
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPicker(String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        SizedBox(height: 12.h),
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16.r),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.contain),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.edit_rounded, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return SwitchListTile(
          title: const Text('Force Dark Mode'),
          value: state.isDarkMode,
          onChanged: (val) {
            context.read<ThemeCubit>().toggleTheme();
          },
        );
      },
    );
  }
}
