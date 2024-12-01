import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class CourseStatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> watchCourseStatus(String idCurso) {
    final today = DateTime.now();
    final dateStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final attendanceStream = _firestore
        .collection('asistencias')
        .doc(dateStr)
        .snapshots();

    final postponeStream = _firestore
        .collection('postpones')
        .where('id_curso', isEqualTo: idCurso)
        .where('created_at', isGreaterThanOrEqualTo: DateTime(today.year, today.month, today.day))
        .where('created_at', isLessThan: DateTime(today.year, today.month, today.day + 1))
        .snapshots();

    return Rx.combineLatest2(
      attendanceStream,
      postponeStream,
          (attendanceDoc, postponeSnapshot) {
        if (attendanceDoc.exists) {
          final attendanceData = attendanceDoc.data() as Map<String, dynamic>;
          if (attendanceData.containsKey(idCurso)) {
            return {
              'type': 'attendance',
              'status': attendanceData[idCurso]['estado']
            };
          }
        }

        if (postponeSnapshot.docs.isNotEmpty) {
          return {
            'type': 'postpone',
            'status': postponeSnapshot.docs.first.data()['estado']
          };
        }

        return {'type': 'none', 'status': 'none'};
      },
    );
  }
}