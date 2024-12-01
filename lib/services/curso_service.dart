import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/logger.dart';
import '../utils/time_ranges.dart';

class CursoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<Map<String, dynamic>>>> getCursosPorDia() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('horarios').get();
      Map<String, List<Map<String, dynamic>>> cursosPorDia = {};

      for (var doc in snapshot.docs) {
        final dia = doc.id;
        final data = doc.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> cursos = [];

        data.forEach((idCurso, cursoData) {
          if (cursoData is Map<String, dynamic>) {
            cursos.add({
              'id_curso': idCurso,
              'seccion': cursoData['seccion'] ?? '',
              'aula': cursoData['aula'] ?? '',
              'curso': cursoData['curso'] ?? '',
              'docente': cursoData['docente'] ?? '',
              'facultad': cursoData['facultad'] ?? '',
              'cantidad': cursoData['cantidad'] ?? 0,
              'hora': cursoData['hora'] ?? '',
            });
          }
        });

        cursosPorDia[dia] = cursos;
      }

      AppLogger.log('Cursos obtenidos exitosamente', prefix: 'CURSO_SERVICE:');
      return cursosPorDia;
    } catch (e) {
      AppLogger.log('Error al obtener cursos: $e', prefix: 'CURSO_SERVICE:');
      rethrow;
    }
  }

  Future<List<Map<String, String>>> getAulasLibresPorDia(String dia) async {
    try {
      final cursosPorDia = await getCursosPorDia();
      final cursos = cursosPorDia[dia] ?? [];

      Map<String, Set<String>> aulasOcupadasPorHorario = {};
      Set<String> todasLasAulas = {};

      // Inicializar horarios
      for (var horario in TimeRanges.getAllTimeRanges()) {
        aulasOcupadasPorHorario[horario] = {};
      }

      // Recolectar aulas y marcar ocupadas
      for (var curso in cursos) {
        String aula = curso['aula'] ?? '';
        String hora = curso['hora'] ?? '';

        if (aula.isNotEmpty) {
          todasLasAulas.add(aula);
          if (hora.isNotEmpty) {
            aulasOcupadasPorHorario[hora]?.add(aula);
          }
        }
      }

      List<Map<String, String>> aulasLibres = [];

      // Procesar cada bloque de horarios
      for (var bloque in TimeRanges.horariosRangos) {
        Set<String> aulasDisponiblesEnBloque = todasLasAulas;

        // Encontrar aulas libres en todo el bloque
        for (var horario in bloque) {
          Set<String> aulasOcupadas = aulasOcupadasPorHorario[horario] ?? {};
          aulasDisponiblesEnBloque = aulasDisponiblesEnBloque
              .difference(aulasOcupadas);
        }

        // Tomar solo 2 aulas por hora
        var aulasSeleccionadas = aulasDisponiblesEnBloque.take(2).toList();

        // Agregar las aulas seleccionadas para cada horario del bloque
        for (var aula in aulasSeleccionadas) {
          for (var horario in bloque) {
            aulasLibres.add({
              'horario': horario,
              'aula': aula
            });
          }
        }
      }

      // Ordenar por horario y aula
      aulasLibres.sort((a, b) {
        int compareHorario = a['horario']!.compareTo(b['horario']!);
        if (compareHorario != 0) return compareHorario;
        return a['aula']!.compareTo(b['aula']!);
      });

      return aulasLibres;

    } catch (e) {
      AppLogger.log('Error al obtener aulas libres: $e', prefix: 'CURSO_SERVICE:');
      rethrow;
    }
  }

 /*
  Future<List<Map<String, String>>> getAulasLibresPorDia(String dia) async {
    try {
      final cursosPorDia = await getCursosPorDia();
      final cursos = cursosPorDia[dia] ?? [];

      List<String> todosLosHorarios = TimeRanges.getAllTimeRanges();
      Map<String, Set<String>> aulasOcupadasPorHorario = {};
      Set<String> todasLasAulas = {};

      // Inicializar horarios
      for (var horario in todosLosHorarios) {
        aulasOcupadasPorHorario[horario] = {};
      }

      // Recolectar aulas y marcar ocupadas
      for (var curso in cursos) {
        String aula = curso['aula'] ?? '';
        String hora = curso['hora'] ?? '';

        if (aula.isNotEmpty) {
          todasLasAulas.add(aula);
          if (hora.isNotEmpty) {
            aulasOcupadasPorHorario[hora]?.add(aula);
          }
        }
      }

      List<Map<String, String>> aulasLibres = [];

      for (var horario in todosLosHorarios) {
        Set<String> aulasOcupadas = aulasOcupadasPorHorario[horario] ?? {};

        for (var aula in todasLasAulas) {
          if (!aulasOcupadas.contains(aula)) {
            aulasLibres.add({
              'horario': horario,
              'aula': aula
            });
          }
        }
      }

      return aulasLibres;
    } catch (e) {
      AppLogger.log('Error al obtener aulas libres: $e', prefix: 'CURSO_SERVICE:');
      rethrow;
    }
  }
  */
}