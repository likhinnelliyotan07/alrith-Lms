import 'package:admin_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/course_detail_bloc.dart';
import 'bloc/course_detail_event.dart';
import 'bloc/course_detail_state.dart';

class CourseDetailView extends StatefulWidget {
  final String courseId;
  const CourseDetailView({super.key, required this.courseId});

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  int _selectedSubjectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseDetailBloc(getIt<AdminRepository>())..add(LoadCourseDetail(widget.courseId)),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Course Syllabus', style: AppTextStyles.h3),
          actions: [
            AppButton(
              text: 'Preview Course',
              isFullWidth: false,
              width: 150.w,
              height: 40.h,
              borderRadius: 8,
              onPressed: () {},
              icon: const Icon(Icons.visibility_rounded, color: Colors.white, size: 18),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: BlocBuilder<CourseDetailBloc, CourseDetailState>(
          builder: (context, state) {
            if (state is CourseDetailLoading) {
              return const AppTableShimmer();
            }
            if (state is CourseDetailLoaded) {
              return Row(
                children: [
                  _buildSubjectsSidebar(state.course),
                  VerticalDivider(width: 1, color: Colors.grey.withOpacity(0.2)),
                  Expanded(
                    child: _buildModulesContent(state.course),
                  ),
                ],
              );
            }
            if (state is CourseDetailFailure) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSubjectsSidebar(Course course) {
    return Container(
      width: 280.w,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subjects', style: AppTextStyles.h4),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: course.subjects.length,
              itemBuilder: (context, index) {
                final subject = course.subjects[index];
                final isSelected = _selectedSubjectIndex == index;
                return ListTile(
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withOpacity(0.05),
                  leading: Icon(
                    Icons.subject_rounded,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  title: Text(
                    subject.title,
                    style: AppTextStyles.bodyM.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => setState(() => _selectedSubjectIndex = index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesContent(Course course) {
    if (course.subjects.isEmpty) {
      return const Center(child: Text('No subjects added yet.'));
    }
    final subject = course.subjects[_selectedSubjectIndex];

    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.title, style: AppTextStyles.h2),
                  Text('${subject.modules.length} Modules in this subject', style: AppTextStyles.bodyS),
                ],
              ),
              AppButton(
                text: 'Add Module',
                isFullWidth: false,
                width: 140.w,
                height: 44.h,
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Expanded(
            child: ListView.builder(
              itemCount: subject.modules.length,
              itemBuilder: (context, index) {
                final module = subject.modules[index];
                return _buildModuleCard(module);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(Module module) {
    return NeumorphicContainer(
      margin: EdgeInsets.only(bottom: 20.h),
      child: ExpansionTile(
        title: Text(module.title, style: AppTextStyles.h4),
        subtitle: Text('${module.contents.length} Items', style: AppTextStyles.bodyS),
        leading: const Icon(Icons.folder_open_rounded, color: Colors.orange),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
          onPressed: () {},
        ),
        children: module.contents.map((content) => _buildContentItem(content)).toList(),
      ),
    );
  }

  Widget _buildContentItem(ContentItem content) {
    IconData icon;
    Color color;
    switch (content.type) {
      case ContentType.video:
        icon = Icons.play_circle_fill_rounded;
        color = Colors.red;
        break;
      case ContentType.pdf:
        icon = Icons.picture_as_pdf_rounded;
        color = Colors.blue;
        break;
      case ContentType.note:
        icon = Icons.notes_rounded;
        color = Colors.green;
        break;
      case ContentType.assignment:
        icon = Icons.assignment_rounded;
        color = Colors.purple;
        break;
      case ContentType.quiz:
        icon = Icons.quiz_rounded;
        color = Colors.orange;
        break;
      case ContentType.exam:
        icon = Icons.description_rounded;
        color = Colors.deepOrange;
        break;
    }

    return ListTile(
      leading: Icon(icon, color: color, size: 24.sp),
      title: Text(content.title, style: AppTextStyles.bodyM),
      subtitle: Text(
        content.type == ContentType.video ? '${content.durationMinutes} mins' : (content.fileName ?? ''),
        style: AppTextStyles.bodyS,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content.isLocked) const Icon(Icons.lock_outline_rounded, size: 16),
          IconButton(icon: const Icon(Icons.edit_rounded, size: 18), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete_rounded, size: 18, color: Colors.red), onPressed: () {}),
        ],
      ),
    );
  }
}
