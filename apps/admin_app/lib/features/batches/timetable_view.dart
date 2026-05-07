import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimetableView extends StatelessWidget {
  final String batchId;
  const TimetableView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBar: AppBar(
        title: Text('Batch Timetable', style: AppTextStyles.h3),
        actions: [
          AppButton(
            text: 'Edit Schedule',
            isFullWidth: false,
            width: 140.w,
            height: 40.h,
            borderRadius: 8,
            onPressed: () {},
            icon: const Icon(Icons.edit_calendar_rounded, color: Colors.white, size: 18),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            _buildDaysHeader(),
            Expanded(
              child: _buildTimeSlotsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysHeader() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      child: Row(
        children: [
          SizedBox(width: 80.w), // Time column spacer
          ...days.map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    final times = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
    return ListView.builder(
      itemCount: times.length,
      itemBuilder: (context, index) {
        return _buildTimeRow(times[index]);
      },
    );
  }

  Widget _buildTimeRow(String time) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Center(
              child: Text(time, style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          ...List.generate(7, (index) => Expanded(
            child: _buildScheduleCell(index, time),
          )),
        ],
      ),
    );
  }

  Widget _buildScheduleCell(int dayIndex, String time) {
    // In a real app, we would check if there is a schedule for this day and time
    bool hasClass = dayIndex < 5 && (time == '09:00' || time == '14:00');

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: hasClass ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: hasClass ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
      ),
      child: hasClass
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Physics', style: AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('Room 101', style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
              ],
            )
          : null,
    );
  }
}
