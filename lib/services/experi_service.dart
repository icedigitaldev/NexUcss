import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';
import 'firestore_manager.dart';

final experiServiceProvider = Provider((ref) => ExperiService(ref.watch(firestoreManagerProvider)));

class ExperiService {
  final FirestoreManager _firestoreManager;
  final CollectionReference _experiCollection = FirebaseFirestore.instance.collection('experimentos');

  ExperiService(this._firestoreManager);

  Future<void> addExperimento(Map<String, dynamic> experimento) async {
    try {
      if (_firestoreManager.isOffline) {
        await _experiCollection.add(experimento);
        AppLogger.log('Experimento guardado localmente', prefix: 'EXPERI_SERVICE:');
      } else {
        await _experiCollection.add(experimento);
        AppLogger.log('Experimento guardado en Firestore', prefix: 'EXPERI_SERVICE:');
      }
    } catch (e) {
      AppLogger.log('Error al guardar experimento: $e', prefix: 'EXPERI_SERVICE:');
      throw Exception('Error al guardar experimento');
    }
  }

  Stream<QuerySnapshot> getExperimentos() {
    return _experiCollection.snapshots();
  }

  Future<void> updateExperimento(String id, Map<String, dynamic> data) async {
    try {
      await _experiCollection.doc(id).update(data);
      AppLogger.log('Experimento actualizado', prefix: 'EXPERI_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al actualizar experimento: $e', prefix: 'EXPERI_SERVICE:');
      throw Exception('Error al actualizar experimento');
    }
  }

  Future<void> deleteExperimento(String id) async {
    try {
      await _experiCollection.doc(id).delete();
      AppLogger.log('Experimento eliminado', prefix: 'EXPERI_SERVICE:');
    } catch (e) {
      AppLogger.log('Error al eliminar experimento: $e', prefix: 'EXPERI_SERVICE:');
      throw Exception('Error al eliminar experimento');
    }
  }
}