import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/postpone_service.dart';
import '../utils/logger.dart';

final postponeServiceProvider = Provider((ref) => PostponeService());

final postponeControllerProvider = StateNotifierProvider<PostponeController, AsyncValue<void>>((ref) {
  return PostponeController(ref.read(postponeServiceProvider), ref);
});

final postponeListProvider = StateNotifierProvider<PostponeListController,
    AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return PostponeListController(ref.read(postponeServiceProvider));
});

class PostponeController extends StateNotifier<AsyncValue<void>> {
  final PostponeService _postponeService;
  final Ref ref;

  PostponeController(this._postponeService, this.ref) : super(const AsyncValue.data(null));

  Future<bool> createPostpone({
    required String idCurso,
    required String cursoNombre,
    required String profesorNombre,
    required DateTime fecha,
    required String horario,
    required String aula,
    required String seccion,
  }) async {
    try {
      state = const AsyncValue.loading();
      AppLogger.log('Creando postergación para curso: $idCurso', prefix: 'POSTPONE');

      await _postponeService.createPostpone(
        idCurso: idCurso,
        cursoNombre: cursoNombre,
        profesorNombre: profesorNombre,
        fecha: fecha,
        horario: horario,
        aula: aula,
        seccion: seccion,
      );

      state = const AsyncValue.data(null);
      AppLogger.log('Postergación creada exitosamente', prefix: 'POSTPONE');

      await Future.delayed(const Duration(milliseconds: 300));
      await ref.read(postponeListProvider.notifier).refresh();
      return true;
    } catch (e) {
      AppLogger.log('Error al crear postergación: $e', prefix: 'ERROR');
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateStatus(String postponeId, String newStatus) async {
    try {
      state = const AsyncValue.loading();
      AppLogger.log('Actualizando estado de postergación: $postponeId', prefix: 'POSTPONE');

      await _postponeService.updatePostponeStatus(postponeId, newStatus);
      state = const AsyncValue.data(null);

      AppLogger.log('Estado actualizado exitosamente', prefix: 'POSTPONE');
      return true;
    } catch (e) {
      AppLogger.log('Error al actualizar estado: $e', prefix: 'ERROR');
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deletePostpone(String postponeId) async {
    try {
      state = const AsyncValue.loading();
      AppLogger.log('Eliminando postergación: $postponeId', prefix: 'POSTPONE');

      await _postponeService.deletePostpone(postponeId);
      state = const AsyncValue.data(null);

      AppLogger.log('Postergación eliminada exitosamente', prefix: 'POSTPONE');

      await Future.delayed(const Duration(milliseconds: 300));
      await ref.read(postponeListProvider.notifier).refresh();
      return true;
    } catch (e) {
      AppLogger.log('Error al eliminar postergación: $e', prefix: 'ERROR');
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateObservation(String postponeId, String observation) async {
    try {
      state = const AsyncValue.loading();
      AppLogger.log('Actualizando observación de postergación: $postponeId', prefix: 'POSTPONE');

      await _postponeService.updatePostponeObservation(postponeId, observation);
      state = const AsyncValue.data(null);

      AppLogger.log('Observación actualizada exitosamente', prefix: 'POSTPONE');
      return true;
    } catch (e) {
      AppLogger.log('Error al actualizar observación: $e', prefix: 'ERROR');
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

class PostponeListController extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final PostponeService _postponeService;

  PostponeListController(this._postponeService) : super(const AsyncValue.loading()) {
    loadPostponedClasses();
  }

  Future<void> loadPostponedClasses() async {
    try {
      state = const AsyncValue.loading();
      AppLogger.log('Cargando lista de postergaciones', prefix: 'POSTPONE');

      final classes = await _postponeService.getPostponedClasses();
      state = AsyncValue.data(classes);

      AppLogger.log('Lista de postergaciones cargada exitosamente', prefix: 'POSTPONE');
    } catch (e) {
      AppLogger.log('Error al cargar lista de postergaciones: $e', prefix: 'ERROR');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    AppLogger.log('Actualizando lista de postergaciones', prefix: 'POSTPONE');
    await loadPostponedClasses();
  }
}