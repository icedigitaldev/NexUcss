import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/logger.dart';

class PostponeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPostpone({
    required String idCurso,
    required String cursoNombre,
    required String profesorNombre,
    required DateTime fecha,
    required String horario,
    required String aula,
    required String seccion,
  }) async {
    try {
      await _firestore.collection('postpones').add({
        'id_curso': idCurso,
        'curso_nombre': cursoNombre,
        'profesor_nombre': profesorNombre,
        'fecha': Timestamp.fromDate(fecha),
        'horario': horario,
        'aula': aula,
        'estado': 'pendiente',
        'seccion': seccion,
        'created_at': FieldValue.serverTimestamp(),
      });
      AppLogger.log('Postergación creada exitosamente', prefix: 'POSTPONE_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al crear postergación: $e', prefix: 'POSTPONE_SERVICE_ERROR:');
      throw Exception('Error al crear la postergación: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPostponedClasses() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('postpones')
          .orderBy('fecha', descending: true)
          .get();

      final List<Map<String, dynamic>> postponedClasses = querySnapshot.docs
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final Timestamp timestamp = data['fecha'] as Timestamp;

        return {
          'id': doc.id,
          'fecha': timestamp.toDate().toString().split(' ')[0],
          'hora': data['horario'],
          'aula': data['aula'],
          'curso': data['curso_nombre'],
          'profesor': data['profesor_nombre'],
          'seccion': data['seccion'],
          'estado': data['estado'],
          'observacion': data['observacion'] ?? '',
        };
      })
          .toList();

      AppLogger.log('Clases postergadas obtenidas: ${postponedClasses.length}',
          prefix: 'POSTPONE_SERVICE:');
      return postponedClasses;
    } catch (e) {
      AppLogger.log('Error al obtener clases postergadas: $e',
          prefix: 'POSTPONE_SERVICE_ERROR:');
      throw Exception('Error al obtener las clases postergadas: $e');
    }
  }

  Future<void> updatePostponeStatus(String postponeId, String newStatus) async {
    try {
      await _firestore.collection('postpones').doc(postponeId).update({
        'estado': newStatus,
        'updated_at': FieldValue.serverTimestamp(),
      });
      AppLogger.log('Estado de postergación actualizado: $newStatus',
          prefix: 'POSTPONE_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al actualizar estado: $e',
          prefix: 'POSTPONE_SERVICE_ERROR:');
      throw Exception('Error al actualizar el estado: $e');
    }
  }

  Future<void> deletePostpone(String postponeId) async {
    try {
      await _firestore.collection('postpones').doc(postponeId).delete();
      AppLogger.log('Postergación eliminada exitosamente', prefix: 'POSTPONE_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al eliminar postergación: $e', prefix: 'POSTPONE_SERVICE_ERROR:');
      throw Exception('Error al eliminar la postergación: $e');
    }
  }

  Future<void> updatePostponeObservation(String postponeId, String observation) async {
    try {
      await _firestore.collection('postpones').doc(postponeId).update({
        'observacion': observation,
        'updated_at': FieldValue.serverTimestamp(),
      });
      AppLogger.log('Observación actualizada exitosamente', prefix: 'POSTPONE_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al actualizar observación: $e', prefix: 'POSTPONE_SERVICE_ERROR:');
      throw Exception('Error al actualizar la observación: $e');
    }
  }
}