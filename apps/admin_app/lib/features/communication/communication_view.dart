import 'package:admin_app/di/injection.dart';
import 'package:core/repositories/communication_repository.dart';
import 'package:core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/communication_bloc.dart';
import 'bloc/communication_event.dart';
import 'bloc/communication_state.dart';

class CommunicationView extends StatefulWidget {
  const CommunicationView({super.key});

  @override
  State<CommunicationView> createState() => _CommunicationViewState();
}

class _CommunicationViewState extends State<CommunicationView> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunicationBloc(getIt<CommunicationRepository>(), getIt<SupabaseService>()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Communications', style: AppTextStyles.h3),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: BlocListener<CommunicationBloc, CommunicationState>(
            listener: (context, state) {
              if (state is CommunicationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                _titleController.clear();
                _messageController.clear();
              }
              if (state is CommunicationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Broadcast Announcement', style: AppTextStyles.h3),
                SizedBox(height: 8.h),
                Text('Send a push notification to all users or specific roles in your organization.', style: AppTextStyles.bodyS),
                SizedBox(height: 24.h),
                NeumorphicContainer(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: 'Announcement Title',
                        hint: 'e.g. Holiday Notice',
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        decoration: AppTheme.inputDecoration(label: 'Target Role (Optional)', hint: 'All Users'),
                        value: _selectedRole,
                        items: ['admin', 'teacher', 'student', 'parent'].map((role) {
                          return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedRole = val),
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        controller: _messageController,
                        label: 'Message',
                        hint: 'Enter your message here...',
                        maxLines: 5,
                      ),
                      SizedBox(height: 24.h),
                      Builder(
                        builder: (context) {
                          final isLoading = context.watch<CommunicationBloc>().state is CommunicationLoading;
                          return AppButton(
                            text: 'Send Announcement',
                            isLoading: isLoading,
                            onPressed: () {
                              if (_titleController.text.isNotEmpty && _messageController.text.isNotEmpty) {
                                context.read<CommunicationBloc>().add(SendAnnouncementRequested(
                                  title: _titleController.text,
                                  message: _messageController.text,
                                  targetRole: _selectedRole,
                                ));
                              }
                            },
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
