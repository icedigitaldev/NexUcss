import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/logger.dart';

class HistoryService {
  final CollectionReference _historyCollection =
  FirebaseFirestore.instance.collection('history');

  Future<void> addHistoryEntry({
    required String dateText,
    required String timeText,
    required String status,
    String userName = 'Usuario Default',
  }) async {
    try {
      await _historyCollection.add({
        'dateText': dateText,
        'timeText': timeText,
        'status': status,
        'userName': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      AppLogger.log('Entrada de historial agregada', prefix: 'HISTORY:');
    } catch (e) {
      AppLogger.log('Error al agregar entrada: $e', prefix: 'ERROR:');
      throw Exception('Error al agregar entrada al historial');
    }
  }

  Stream<List<Map<String, dynamic>>> getHistoryStream() {
    return _historyCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id,
        };
      }).toList();
    });
  }
}