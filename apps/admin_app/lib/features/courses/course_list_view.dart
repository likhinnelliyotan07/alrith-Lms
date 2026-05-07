import 'package:admin_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'bloc/course_bloc.dart';
import 'bloc/course_event.dart';
import 'bloc/course_state.dart';

class CourseListView extends StatelessWidget {
  const CourseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseBloc(getIt<AdminRepository>())..add(LoadCourses()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Course Management', style: AppTextStyles.h3),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 24.h),
              Expanded(
                child: BlocBuilder<CourseBloc, CourseState>(
                  builder: (context, state) {
                    if (state is CourseLoading) {
                      return const AppTableShimmer();
                    }
                    if (state is CoursesLoaded) {
                      return _buildCourseGrid(context, state.courses);
                    }
                    if (state is CourseFailure) {
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
            hint: 'Search courses...',
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: (val) {
              // Implementation for search filtering
            },
          ),
        ),
        SizedBox(width: 16.w),
        AppButton(
          text: 'Create Course',
          isFullWidth: false,
          width: 180.w,
          height: 54.h,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          onPressed: () {
            // Navigate to Create Course View or Show Dialog
          },
        ),
      ],
    );
  }

  Widget _buildCourseGrid(BuildContext context, List<Course> courses) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1.sw > 1200 ? 4 : (1.sw > 800 ? 3 : 2),
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 0.85,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(context, course);
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return NeumorphicContainer(
      child: InkWell(
        onTap: () => context.push('/courses/${course.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  image: DecorationImage(
                    image: NetworkImage(course.thumbnail ?? 'https://via.placeholder.com/300x200'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '\$${course.price}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: AppTextStyles.h4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${course.subjects.length} Subjects • 24 Modules', // Placeholder modules count
                    style: AppTextStyles.bodyS,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.orange, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text('4.8', style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      _buildStatusBadge(course.isActive ? 'Active' : 'Inactive'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'Active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
