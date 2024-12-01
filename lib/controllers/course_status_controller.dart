import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/course_status_service.dart';

final courseStatusServiceProvider = Provider<CourseStatusService>((ref) {
  return CourseStatusService();
});

final courseStatusProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, String idCurso) {
  final service = ref.watch(courseStatusServiceProvider);
  return service.watchCourseStatus(idCurso);
});

final courseColorProvider = Provider.family<Color, Map<String, dynamic>>((ref, status) {
  if (status['type'] == 'attendance') {
    if (status['status'] == 'AS') return Colors.green[50]!;
    if (status['status'] == 'TA') return Colors.orange[50]!;
    if (status['status'] == 'FA') return Colors.pink[50]!;
  } else if (status['type'] == 'postpone') {
    return Colors.blue[50]!;
  }
  return const Color(0xfff7f9fb);
});