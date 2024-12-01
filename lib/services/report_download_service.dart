import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/logger.dart';

class ReportDownloadService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAsistencias(DateTime startDate, DateTime endDate) async {
    try {
      AppLogger.log('Iniciando obtención de asistencias');
      List<Map<String, dynamic>> asistencias = [];

      for (DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
        String dateStr = date.toString().split(' ')[0];
        AppLogger.log('Consultando fecha: $dateStr');

        final docSnapshot = await _firestore
            .collection('asistencias')
            .doc(dateStr)
            .get();

        if (docSnapshot.exists) {
          AppLogger.log('Documento encontrado para fecha: $dateStr');
          Map<String, dynamic> dayData = Map<String, dynamic>.from(docSnapshot.data()!);
          dayData.forEach((key, value) {
            if (value is Map) {
              asistencias.add(Map<String, dynamic>.from(value as Map));
            }
          });
        } else {
          AppLogger.log('No hay datos para fecha: $dateStr');
        }
      }

      AppLogger.log('Total asistencias obtenidas: ${asistencias.length}');
      return List<Map<String, dynamic>>.from(asistencias);
    } catch (e) {
      AppLogger.log('Error en getAsistencias: $e');
      throw Exception('Error obteniendo asistencias: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPostpones(DateTime startDate, DateTime endDate) async {
    try {
      AppLogger.log('Iniciando obtención de postergaciones');
      final querySnapshot = await _firestore
          .collection('postpones')
          .where('fecha', isGreaterThanOrEqualTo: startDate)
          .where('fecha', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> postpones = querySnapshot.docs
          .map((doc) => Map<String, dynamic>.from(doc.data()))
          .toList();

      AppLogger.log('Total postergaciones obtenidas: ${postpones.length}');
      return List<Map<String, dynamic>>.from(postpones);
    } catch (e) {
      AppLogger.log('Error en getPostpones: $e');
      throw Exception('Error obteniendo postpones: $e');
    }
  }
}