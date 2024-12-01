import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/logger.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarAsistencia({
    required String idCurso,
    required String estado,
    required String ubicacion,
    required String numseccion,
    required String nombreProfesor,
    String? observacion,
    String? userId,
  }) async {
    try {
      if (idCurso.isEmpty || estado.isEmpty || ubicacion.isEmpty) {
        throw Exception('Los campos idCurso, estado y ubicacion son obligatorios');
      }

      final DateTime now = DateTime.now();
      final String fechaDoc = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      Map<String, dynamic> asistenciaData = {
        'hora': Timestamp.now(),
        'estado': estado,
        'ubicacion': ubicacion,
        'seccion': numseccion,
        'profesor': nombreProfesor,
        'usuario': userId?.isNotEmpty == true ? userId : 'default_user',
      };

      if (observacion?.isNotEmpty == true) {
        asistenciaData['observacion'] = observacion;
      }

      final asistencia = {
        idCurso: asistenciaData
      };

      await _firestore
          .collection('asistencias')
          .doc(fechaDoc)
          .set(asistencia, SetOptions(merge: true));

      AppLogger.log('Asistencia registrada exitosamente', prefix: 'ATTENDANCE_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al registrar asistencia: $e', prefix: 'ATTENDANCE_SERVICE:');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> obtenerAsistenciasPorFecha(String fecha) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('asistencias')
          .doc(fecha)
          .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      AppLogger.log('Error al obtener asistencias: $e', prefix: 'ATTENDANCE_SERVICE:');
      rethrow;
    }
  }

  Future<Map<String, Map<String, dynamic>>> obtenerAsistenciasPorRango({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      Map<String, Map<String, dynamic>> asistencias = {};

      for (DateTime fecha = fechaInicio;
      fecha.isBefore(fechaFin.add(const Duration(days: 1)));
      fecha = fecha.add(const Duration(days: 1))) {

        final String fechaDoc = "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";

        final asistenciasDia = await obtenerAsistenciasPorFecha(fechaDoc);
        if (asistenciasDia != null) {
          asistencias[fechaDoc] = asistenciasDia;
        }
      }

      return asistencias;
    } catch (e) {
      AppLogger.log('Error al obtener asistencias por rango: $e', prefix: 'ATTENDANCE_SERVICE:');
      rethrow;
    }
  }
}