import 'package:admin_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/teacher_bloc.dart';
import 'bloc/teacher_event.dart';
import 'bloc/teacher_state.dart';
import 'widgets/add_teacher_dialog.dart';

class TeacherListView extends StatelessWidget {
  const TeacherListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherBloc(getIt<AdminRepository>())..add(const LoadTeachers()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Teacher Management', style: AppTextStyles.h3),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 24.h),
              Expanded(
                child: BlocBuilder<TeacherBloc, TeacherState>(
                  builder: (context, state) {
                    if (state is TeacherLoading) {
                      return const AppTableShimmer();
                    }
                    if (state is TeachersLoaded) {
                      return _buildTable(context, state.teachers);
                    }
                    if (state is TeacherFailure) {
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
            hint: 'Search teachers...',
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: (val) {
              context.read<TeacherBloc>().add(LoadTeachers(query: val));
            },
          ),
        ),
        SizedBox(width: 16.w),
        AppButton(
          text: 'Add Teacher',
          isFullWidth: false,
          width: 180.w,
          height: 54.h,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          onPressed: () => _showAddTeacherDialog(context),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, List<Profile> teachers) {
    return NeumorphicContainer(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primary.withOpacity(0.05)),
          columns: [
            DataColumn(label: Text('Name', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Email', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold))),
          ],
          rows: teachers.map((teacher) {
            return DataRow(cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(teacher.fullName[0], style: TextStyle(fontSize: 12.sp)),
                    ),
                    SizedBox(width: 12.w),
                    Text(teacher.fullName, style: AppTextStyles.bodyM),
                  ],
                ),
              ),
              DataCell(Text(teacher.email, style: AppTextStyles.bodyS)),
              DataCell(_buildStatusBadge('Active')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                    onPressed: () {},
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showAddTeacherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dlgContext) => AddTeacherDialog(
        repository: getIt<AdminRepository>(),
        onSuccess: () {
          Navigator.pop(dlgContext);
          context.read<TeacherBloc>().add(const AddTeacherEvent());
        },
      ),
    );
  }
}
