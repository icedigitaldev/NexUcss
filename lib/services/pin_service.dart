import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/logger.dart';

class PinService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función para crear usuarios iniciales (comentar después de usar)
  Future<void> createInitialUsers() async {
    try {
      await _firestore.collection('users').add({
        'name': 'Usuario 1',
        'pin': '1234',
        'isBlocked': false,
        'failedAttempts': 0,
        'lastAttempt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').add({
        'name': 'Usuario 2',
        'pin': '5678',
        'isBlocked': false,
        'failedAttempts': 0,
        'lastAttempt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      AppLogger.log('Usuarios creados exitosamente', prefix: 'PIN_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al crear usuarios: $e', prefix: 'PIN_SERVICE:');
    }
  }

  Future<Map<String, dynamic>> validatePin(String pin) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('pin', isEqualTo: pin)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        return {'isValid': false, 'message': 'PIN incorrecto'};
      }

      final userData = result.docs.first.data() as Map<String, dynamic>;
      final String userId = result.docs.first.id;

      if (userData['isBlocked'] == true) {
        return {'isValid': false, 'message': 'Usuario bloqueado'};
      }

      // Resetear intentos fallidos si el PIN es correcto
      await _firestore.collection('users').doc(userId).update({
        'failedAttempts': 0,
        'lastAttempt': FieldValue.serverTimestamp(),
      });

      return {
        'isValid': true,
        'userData': userData,
        'message': 'PIN válido'
      };
    } catch (e) {
      AppLogger.log('Error al validar PIN: $e', prefix: 'PIN_SERVICE:');
      return {'isValid': false, 'message': 'Error al validar PIN'};
    }
  }

  Future<void> registerFailedAttempt(String pin) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('pin', isEqualTo: pin)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        final String userId = result.docs.first.id;
        final userData = result.docs.first.data() as Map<String, dynamic>;
        final int failedAttempts = (userData['failedAttempts'] ?? 0) + 1;

        await _firestore.collection('users').doc(userId).update({
          'failedAttempts': failedAttempts,
          'lastAttempt': FieldValue.serverTimestamp(),
          'isBlocked': failedAttempts >= 3,
        });
      }
    } catch (e) {
      AppLogger.log('Error al registrar intento fallido: $e', prefix: 'PIN_SERVICE:');
    }
  }
}