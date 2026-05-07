import 'package:admin_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/dashboard_bloc.dart';
import 'bloc/dashboard_event.dart';
import 'bloc/dashboard_state.dart';
import 'widgets/stat_card.dart';
import 'widgets/revenue_chart.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(getIt<AdminRepository>())..add(LoadDashboardStats()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard', style: AppTextStyles.h3),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        drawer: _buildSidebar(context),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(4, (i) => Expanded(child: Padding(
                        padding: EdgeInsets.only(right: i < 3 ? 16.w : 0),
                        child: AppShimmer.rectangular(height: 120.h),
                      ))),
                    ),
                    SizedBox(height: 32.h),
                    AppShimmer.rectangular(height: 300.h),
                  ],
                ),
              );
            }
            if (state is DashboardLoaded) {
              return SingleChildScrollView(
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
                            Text('Overview', style: AppTextStyles.h2),
                            Text('Last updated 5 mins ago', style: AppTextStyles.bodyS),
                          ],
                        ),
                        AppButton(
                          text: 'Export Report',
                          isFullWidth: false,
                          width: 140.w,
                          height: 44.h,
                          borderRadius: 8,
                          onPressed: () {},
                          icon: const Icon(Icons.file_download_outlined, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    GridView.count(
                      crossAxisCount: 1.sw > 1000 ? 4 : (1.sw > 600 ? 2 : 1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.h,
                      childAspectRatio: 2.0,
                      children: [
                        StatCard(
                          title: 'Total Students',
                          value: state.stats['totalStudents'].toString(),
                          icon: Icons.people_rounded,
                          color: Colors.blue,
                        ),
                        StatCard(
                          title: 'Total Teachers',
                          value: state.stats['totalTeachers'].toString(),
                          icon: Icons.school_rounded,
                          color: Colors.purple,
                        ),
                        StatCard(
                          title: 'Active Courses',
                          value: state.stats['activeCourses'].toString(),
                          icon: Icons.book_rounded,
                          color: Colors.orange,
                        ),
                        StatCard(
                          title: 'Monthly Revenue',
                          value: '\$${state.stats['revenue']}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    const RevenueChart(),
                    SizedBox(height: 40.h),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recent Activity', style: AppTextStyles.h3),
                              SizedBox(height: 16.h),
                              NeumorphicContainer(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final activities = [
                                      'New student enrolled in Physics Batch A',
                                      'Teacher uploaded new study material for Chemistry',
                                      'Payment received from John Doe',
                                      'New Course "Machine Learning 101" published',
                                    ];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.primary.withOpacity(0.1),
                                        child: Icon(Icons.info_outline, color: AppColors.primary, size: 20.sp),
                                      ),
                                      title: Text(activities[index], style: AppTextStyles.bodyM),
                                      subtitle: Text('${index + 1} hours ago', style: AppTextStyles.bodyS),
                                      trailing: const Icon(Icons.chevron_right_rounded),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Top Batches', style: AppTextStyles.h3),
                              SizedBox(height: 16.h),
                              NeumorphicContainer(
                                child: Column(
                                  children: List.generate(3, (i) => ListTile(
                                    title: Text('Batch ${String.fromCharCode(65 + i)}', style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: Text('45 Students', style: AppTextStyles.bodyS),
                                    trailing: Text('${85 - i * 5}% full', style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 280.w,
      color: Theme.of(context).cardTheme.color,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(Icons.auto_graph_rounded, size: 32.sp, color: Colors.white),
                ),
                SizedBox(height: 12.h),
                Text('Arlith Admin', style: AppTextStyles.h3),
              ],
            ),
          ),
          _buildMenuItem(context, Icons.dashboard_rounded, 'Dashboard', '/', true),
          _buildMenuItem(context, Icons.people_rounded, 'Students', '/students', false),
          _buildMenuItem(context, Icons.school_rounded, 'Teachers', '/teachers', false),
          _buildMenuItem(context, Icons.videocam_rounded, 'Live Classes', '/live-classes', false),
          _buildMenuItem(context, Icons.book_rounded, 'Courses', '/courses', false),
          _buildMenuItem(context, Icons.payments_rounded, 'Financials', '/financials', false),
          const Spacer(),
          _buildMenuItem(context, Icons.settings_rounded, 'Settings', '/settings', false),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route, bool isSelected) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        title,
        style: isSelected
            ? AppTextStyles.bodyM.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)
            : AppTextStyles.bodyM,
      ),
      selected: isSelected,
      onTap: () => context.go(route),
    );
  }
}
