import 'package:admin_app/di/injection.dart';
import 'package:core/repositories/parent_repository.dart';
import 'package:core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/parent_bloc.dart';
import 'bloc/parent_event.dart';
import 'bloc/parent_state.dart';

class ParentListView extends StatelessWidget {
  const ParentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentBloc(getIt<ParentRepository>(), getIt<SupabaseService>())..add(const LoadParents()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Parent Management', style: AppTextStyles.h3),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 24.h),
              Expanded(
                child: BlocBuilder<ParentBloc, ParentState>(
                  builder: (context, state) {
                    if (state is ParentLoading) {
                      return const AppTableShimmer();
                    }
                    if (state is ParentsLoaded) {
                      return _buildTable(context, state.parents);
                    }
                    if (state is ParentFailure) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            hint: 'Search by name or email...',
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: (val) {
              context.read<ParentBloc>().add(LoadParents(query: val));
            },
          ),
        ),
        SizedBox(width: 16.w),
        AppButton(
          text: 'Add Parent',
          isFullWidth: false,
          width: 180.w,
          height: 54.h,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          onPressed: () => _showAddParentDialog(context),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, List<Profile> parents) {
    return NeumorphicContainer(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primary.withOpacity(0.05)),
          columns: [
            DataColumn(label: Text('Name', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Email', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Children', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Phone', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
          ],
          rows: parents.map((parent) {
            return DataRow(cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(parent.fullName[0], style: TextStyle(fontSize: 12.sp)),
                    ),
                    SizedBox(width: 12.w),
                    Text(parent.fullName, style: AppTextStyles.bodyM),
                  ],
                ),
              ),
              DataCell(Text(parent.email, style: AppTextStyles.bodyS)),
              DataCell(Text('2 Children', style: AppTextStyles.bodyS)), // Placeholder for child count
              DataCell(Text(parent.phoneNumber ?? 'N/A', style: AppTextStyles.bodyS)),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.link_rounded, color: Colors.green, size: 20),
                    tooltip: 'Link Child',
                    onPressed: () => _showLinkChildDialog(context, parent),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                    onPressed: () {
                       context.read<ParentBloc>().add(DeleteParent(parent.id));
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _showAddParentDialog(BuildContext context) {
    // Reusing the style from StudentListView
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Parent', style: AppTextStyles.h3),
        content: SizedBox(
          width: 400.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppTextField(label: 'Full Name', hint: 'Enter full name'),
              SizedBox(height: 16.h),
              const AppTextField(label: 'Email', hint: 'Enter email address', keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16.h),
              const AppTextField(label: 'Phone', hint: 'Enter phone number'),
              SizedBox(height: 16.h),
              const AppTextField(label: 'Initial Password', hint: 'Enter password', obscureText: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          AppButton(
            text: 'Save Parent',
            isFullWidth: false,
            width: 140.w,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLinkChildDialog(BuildContext context, Profile parent) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Link Child to ${parent.fullName}', style: AppTextStyles.h3),
        content: SizedBox(
          width: 400.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppTextField(label: 'Search Student', hint: 'Enter student name or email'),
              SizedBox(height: 16.h),
              Text('Results will appear here...', style: AppTextStyles.bodyS),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          AppButton(
            text: 'Link Selected',
            isFullWidth: false,
            width: 140.w,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
