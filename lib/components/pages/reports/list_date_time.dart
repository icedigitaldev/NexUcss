import 'package:flutter/material.dart';
import '../../../widgets/pages/reports/custom_date_time_row.dart';

class ListDateTime extends StatelessWidget {
  final List<Map<String, String>> dateTimeData;

  const ListDateTime({
    Key? key,
    required this.dateTimeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: dateTimeData.length,
        itemBuilder: (context, index) {
          final data = dateTimeData[index];
          return CustomDateTimeRow(
            dateText: data['dateText'] ?? '',
            timeText: data['timeText'] ?? '',
            status: data['status'] ?? 'download',
            userName: data['userName'] ?? '',
          );
        },
      ),
    );
  }
}