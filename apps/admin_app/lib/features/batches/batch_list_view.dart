import 'package:admin_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'bloc/batch_bloc.dart';
import 'bloc/batch_event.dart';
import 'bloc/batch_state.dart';

class BatchListView extends StatelessWidget {
  const BatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BatchBloc(getIt<AdminRepository>())..add(LoadBatches()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Batch Management', style: AppTextStyles.h3),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 24.h),
              Expanded(
                child: BlocBuilder<BatchBloc, BatchState>(
                  builder: (context, state) {
                    if (state is BatchLoading) {
                      return const AppTableShimmer();
                    }
                    if (state is BatchesLoaded) {
                      return _buildBatchList(context, state.batches);
                    }
                    if (state is BatchFailure) {
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
            hint: 'Search batches...',
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: (val) {},
          ),
        ),
        SizedBox(width: 16.w),
        AppButton(
          text: 'Create Batch',
          isFullWidth: false,
          width: 180.w,
          height: 54.h,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBatchList(BuildContext context, List<Batch> batches) {
    return ListView.builder(
      itemCount: batches.length,
      itemBuilder: (context, index) {
        final batch = batches[index];
        return _buildBatchCard(context, batch);
      },
    );
  }

  Widget _buildBatchCard(BuildContext context, Batch batch) {
    return NeumorphicContainer(
      margin: EdgeInsets.only(bottom: 16.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        title: Text(batch.name, style: AppTextStyles.h4),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text('Capacity: ${batch.enrolledCount}/${batch.capacity} Students', style: AppTextStyles.bodyS),
            SizedBox(height: 4.h),
            Text('Starts: ${batch.startDate.toString().split(' ')[0]}', style: AppTextStyles.bodyS),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: 'View Timetable',
              isFullWidth: false,
              width: 150.w,
              height: 40.h,
              borderRadius: 8,
              onPressed: () => context.push('/batches/${batch.id}/timetable'),
            ),
            SizedBox(width: 12.w),
            IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () {}),
            IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
