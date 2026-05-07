import 'package:injectable/injectable.dart';
import 'package:core/core.dart';

import 'package:core/auth/bloc/auth_bloc.dart';
import 'package:core/network/app_router.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_view.dart';
import '../features/students/student_list_view.dart';
import '../features/teachers/teacher_list_view.dart';
import '../features/live_classes/live_class_view.dart';
import '../features/courses/course_list_view.dart';
import '../features/courses/course_detail_view.dart';
import '../features/batches/batch_list_view.dart';
import '../features/batches/timetable_view.dart';
import '../features/settings/white_label_settings_view.dart';
import '../features/parents/parent_list_view.dart';
import '../features/finance/finance_dashboard_view.dart';
import '../features/communication/communication_view.dart';
import '../features/settings/audit_log_view.dart';


@module
abstract class AdminModule {
  @lazySingleton
  AppRouter provideRouter(AuthBloc authBloc) {
    return AppRouter(
      authBloc,
      extraRoutes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AdminDashboardView(),
        ),
        GoRoute(
          path: '/students',
          builder: (context, state) => const StudentListView(),
        ),
        GoRoute(
          path: '/teachers',
          builder: (context, state) => const TeacherListView(),
        ),
        GoRoute(
          path: '/live-classes',
          builder: (context, state) => const LiveClassView(),
        ),
        GoRoute(
          path: '/courses',
          builder: (context, state) => const CourseListView(),
        ),
        GoRoute(
          path: '/courses/:id',
          builder: (context, state) => CourseDetailView(courseId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/batches',
          builder: (context, state) => const BatchListView(),
        ),
        GoRoute(
          path: '/batches/:id/timetable',
          builder: (context, state) => TimetableView(batchId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const WhiteLabelSettingsView(),
        ),
        GoRoute(
          path: '/parents',
          builder: (context, state) => const ParentListView(),
        ),
        GoRoute(
          path: '/financials',
          builder: (context, state) => const FinanceDashboardView(),
        ),
        GoRoute(
          path: '/communications',
          builder: (context, state) => const CommunicationView(),
        ),
        GoRoute(
          path: '/settings/audit-logs',
          builder: (context, state) => const AuditLogView(),
        ),
      ],
    );
  }
}


