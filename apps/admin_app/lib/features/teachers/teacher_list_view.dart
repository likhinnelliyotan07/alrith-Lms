import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherListView extends StatelessWidget {
  const TeacherListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBar: AppBar(
        title: Text('Teacher Management', style: AppTextStyles.h3),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: NeumorphicContainer(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search teachers...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Add Teacher'),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return NeumorphicContainer(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Subject')),
          DataColumn(label: Text('Experience')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          _buildRow('Dr. John Doe', 'Physics', '10 Years'),
          _buildRow('Prof. Sarah Smith', 'Mathematics', '15 Years'),
        ],
      ),
    );
  }

  DataRow _buildRow(String name, String subject, String exp) {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(subject)),
      DataCell(Text(exp)),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
        ],
      )),
    ]);
  }
}
