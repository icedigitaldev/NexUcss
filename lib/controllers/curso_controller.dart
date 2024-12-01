import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/curso_service.dart';
import 'dart:async';

class CursoController extends StateNotifier<AsyncValue<Map<String, List<Map<String, dynamic>>>>> {
  final CursoService _cursoService;

  CursoController(this._cursoService) : super(const AsyncValue.loading()) {
    loadCursos();
  }

  Future<void> loadCursos() async {
    try {
      state = const AsyncValue.loading();
      final cursos = await _cursoService.getCursosPorDia();
      if (mounted) {
        state = AsyncValue.data(cursos);
      }
    } catch (e) {
      if (mounted) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  Future<void> refresh() async {
    await loadCursos();
  }
}

class SearchState {
  final String query;
  final bool isSearching;

  SearchState({this.query = '', this.isSearching = false});

  SearchState copyWith({String? query, bool? isSearching}) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class SearchController extends StateNotifier<SearchState> {
  Timer? _debounce;

  SearchController() : super(SearchState());

  void setSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {
      state = state.copyWith(query: query, isSearching: query.isNotEmpty);
    });
  }

  void clearSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    state = SearchState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final cursoControllerProvider = StateNotifierProvider<CursoController, AsyncValue<Map<String, List<Map<String, dynamic>>>>>(
        (ref) => CursoController(CursoService())
);

final selectedDayProvider = StateProvider<String>((ref) => 'LUNES');

final searchControllerProvider = StateNotifierProvider<SearchController, SearchState>((ref) => SearchController());

final cursosDelDiaProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final cursosAsync = ref.watch(cursoControllerProvider);
  final selectedDay = ref.watch(selectedDayProvider);

  return cursosAsync.when(
    data: (cursos) => cursos[selectedDay] ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});

final todosCursosProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final cursosAsync = ref.watch(cursoControllerProvider);

  return cursosAsync.when(
    data: (cursos) {
      List<Map<String, dynamic>> todosCursos = [];
      cursos.forEach((_, cursosDia) {
        todosCursos.addAll(cursosDia);
      });
      return todosCursos;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final cursosFiltradosPorHoraProvider = Provider.family<List<Map<String, dynamic>>, String?>((ref, selectedHorario) {
  final searchState = ref.watch(searchControllerProvider);

  if (searchState.isSearching) {
    final todosCursos = ref.watch(todosCursosProvider);
    final query = searchState.query.toLowerCase();

    return todosCursos.where((curso) =>
    curso['curso'].toString().toLowerCase().contains(query) ||
        curso['docente'].toString().toLowerCase().contains(query) ||
        curso['facultad'].toString().toLowerCase().contains(query) ||
        curso['seccion'].toString().toLowerCase().contains(query) ||
        curso['aula'].toString().toLowerCase().contains(query)
    ).toList();
  }

  final cursos = ref.watch(cursosDelDiaProvider);
  if (selectedHorario == null) return cursos;
  return cursos.where((curso) => curso['hora'] == selectedHorario).toList();
});

class AulasLibresController extends StateNotifier<AsyncValue<List<Map<String, String>>>> {
  final CursoService _cursoService;

  AulasLibresController(this._cursoService) : super(const AsyncValue.data([]));

  Future<void> cargarAulasLibres(String dia) async {
    try {
      state = const AsyncValue.loading();
      final aulasLibres = await _cursoService.getAulasLibresPorDia(dia);
      state = AsyncValue.data(aulasLibres);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final aulasLibresProvider = StateNotifierProvider<AulasLibresController, AsyncValue<List<Map<String, String>>>>(
        (ref) => AulasLibresController(CursoService())
);