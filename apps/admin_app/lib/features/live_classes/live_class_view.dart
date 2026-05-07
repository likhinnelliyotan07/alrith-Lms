import 'package:admin_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/live_class_bloc.dart';
import 'bloc/live_class_event.dart';
import 'bloc/live_class_state.dart';

class LiveClassView extends StatelessWidget {
  const LiveClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiveClassBloc(getIt<AdminRepository>())..add(LoadLiveClasses()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Live Classes', style: AppTextStyles.h3),
          actions: [
            AppButton(
              text: 'Schedule Class',
              isFullWidth: false,
              width: 160.w,
              height: 40.h,
              borderRadius: 8,
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: BlocBuilder<LiveClassBloc, LiveClassState>(
          builder: (context, state) {
            if (state is LiveClassLoading) {
              return const AppTableShimmer();
            }
            if (state is LiveClassesLoaded) {
              return ListView.builder(
                padding: EdgeInsets.all(24.w),
                itemCount: state.liveClasses.length,
                itemBuilder: (context, index) {
                  final liveClass = state.liveClasses[index];
                  final isOngoing = liveClass['status'] == 'ongoing';

                  return NeumorphicContainer(
                    margin: EdgeInsets.only(bottom: 20.h),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: (isOngoing ? Colors.red : Colors.blue).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              isOngoing ? Icons.videocam_rounded : Icons.calendar_today_rounded,
                              color: isOngoing ? Colors.red : Colors.blue,
                              size: 32.sp,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(liveClass['title'], style: AppTextStyles.h4),
                                SizedBox(height: 4.h),
                                Text(
                                  '${liveClass['instructor']} • ${liveClass['startTime']}',
                                  style: AppTextStyles.bodyS,
                                ),
                                if (isOngoing) ...[
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${liveClass['studentsCount']} Students active',
                                        style: TextStyle(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          AppButton(
                            text: isOngoing ? 'Join Now' : 'Details',
                            isFullWidth: false,
                            width: 120.w,
                            height: 44.h,
                            gradient: isOngoing ? AppGradients.primary : null,
                            color: isOngoing ? null : Colors.grey[200],
                            textColor: isOngoing ? Colors.white : Colors.black87,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if (state is LiveClassFailure) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
