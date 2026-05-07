import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
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
      body: child,
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
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
          _buildMenuItem(context, Icons.dashboard_rounded, 'Dashboard', '/', location),
          _buildMenuItem(context, Icons.people_rounded, 'Students', '/students', location),
          _buildMenuItem(context, Icons.family_restroom_rounded, 'Parents', '/parents', location),
          _buildMenuItem(context, Icons.school_rounded, 'Teachers', '/teachers', location),
          _buildMenuItem(context, Icons.videocam_rounded, 'Live Classes', '/live-classes', location),
          _buildMenuItem(context, Icons.book_rounded, 'Courses', '/courses', location),
          _buildMenuItem(context, Icons.payments_rounded, 'Financials', '/financials', location),
          _buildMenuItem(context, Icons.campaign_rounded, 'Communications', '/communications', location),
          const Spacer(),
          _buildMenuItem(context, Icons.settings_rounded, 'Settings', '/settings', location),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route, String currentLocation) {
    final isSelected = currentLocation == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        title,
        style: isSelected
            ? AppTextStyles.bodyM.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)
            : AppTextStyles.bodyM,
      ),
      selected: isSelected,
      onTap: () {
        context.go(route);
        // If drawer is open, close it (mobile)
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
