import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/logger.dart';

class ExcelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadHorariosToFirestore(
      Map<String, Map<String, Map<String, dynamic>>> horariosPorDia
      ) async {
    try {
      final batch = _firestore.batch();
      final horariosRef = _firestore.collection('horarios');

      horariosPorDia.forEach((dia, horarios) {
        final diaRef = horariosRef.doc(dia);
        batch.set(diaRef, horarios);
        AppLogger.log('Procesando día: $dia', prefix: 'EXCEL_SERVICE:');
      });

      await batch.commit();
      AppLogger.log('Datos subidos exitosamente a Firestore', prefix: 'EXCEL_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al subir datos a Firestore: $e', prefix: 'ERROR:');
      rethrow;
    }
  }
}