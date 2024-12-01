import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/experi_service.dart';
import '../services/firestore_manager.dart';
import '../utils/logger.dart';

final experiControllerProvider = StateNotifierProvider<ExperiController, bool>((ref) {
  return ExperiController(ref.watch(experiServiceProvider), ref.watch(firestoreManagerProvider));
});

class ExperiController extends StateNotifier<bool> {
  final ExperiService _experiService;
  final FirestoreManager _firestoreManager;

  ExperiController(this._experiService, this._firestoreManager) : super(true);

  void toggleOfflineMode() {
    state = !state;
    _firestoreManager.setOfflineMode(state);
    AppLogger.log('Modo offline: $state', prefix: 'EXPERI_CONTROLLER:');
  }

  Future<void> addExperimento(Map<String, dynamic> experimento) async {
    await _experiService.addExperimento(experimento);
  }

  Stream getExperimentos() {
    return _experiService.getExperimentos();
  }

  Future<void> updateExperimento(String id, Map<String, dynamic> data) async {
    await _experiService.updateExperimento(id, data);
  }

  Future<void> deleteExperimento(String id) async {
    await _experiService.deleteExperimento(id);
  }
}