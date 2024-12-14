import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/curso_controller.dart';
import '../../../controllers/course_status_controller.dart';
import '../../../widgets/pages/academic/curso_card.dart';
import '../../../utils/logger.dart';
import 'add_attendance.dart';

class CursoList extends ConsumerWidget {
  final String? selectedHorario;
  final DateTime selectedDate;

  const CursoList({
    super.key,
    this.selectedHorario,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursosAsync = ref.watch(cursoControllerProvider);
    final searchQuery = ref.watch(searchControllerProvider).query;

    // Actualizar el día seleccionado usando un microtask
    Future.microtask(() {
      ref.read(selectedDayProvider.notifier).state = obtenerDiaDeSemana(selectedDate);
    });

    AppLogger.log(
        'Construyendo CursoList - Horario: $selectedHorario, Fecha: $selectedDate',
        prefix: 'CURSO_LIST:'
    );

    return cursosAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      ),
      error: (error, stack) {
        AppLogger.log('Error al cargar cursos: $error', prefix: 'CURSO_LIST:');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error al cargar los cursos\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        );
      },
      data: (_) {
        final cursos = ref.watch(cursosFiltradosPorHoraProvider(selectedHorario));

        if (cursos.isEmpty) {
          return RefreshIndicator(
            color: Colors.deepPurple,
            backgroundColor: Colors.white,
            onRefresh: () async {
              AppLogger.log('Refrescando lista de cursos', prefix: 'CURSO_LIST:');
              return await ref.read(cursoControllerProvider.notifier).refresh();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isEmpty
                              ? 'No hay cursos disponibles en este horario'
                              : 'No se encontraron resultados para "$searchQuery"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: Colors.deepPurple,
          backgroundColor: Colors.white,
          onRefresh: () async {
            AppLogger.log('Refrescando lista de cursos', prefix: 'CURSO_LIST:');
            return await ref.read(cursoControllerProvider.notifier).refresh();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: cursos.length,
            itemBuilder: (context, index) {
              final curso = cursos[index];
              final idCurso = curso['id_curso']?.toString() ?? '';
              final statusAsync = ref.watch(courseStatusProvider(idCurso));

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    AppLogger.log(
                        'Navegando a AddAttendance para curso: ${curso['curso']}',
                        prefix: 'CURSO_LIST:'
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddAttendance(
                        cursoNombre: curso['curso']?.toString() ?? '',
                        nombreProfe: curso['docente']?.toString() ?? '',
                        numAula: curso['aula']?.toString() ?? '',
                        nomFacultad: curso['facultad']?.toString() ?? '',
                        canAlumnos: curso['cantidad'] ?? 0,
                        numseccion: curso['seccion']?.toString() ?? '',
                        idCurso: idCurso,
                      ),
                    ));
                  },
                  child: CursoCard(
                    seccion: curso['seccion']?.toString() ?? '',
                    aula: curso['aula']?.toString() ?? '',
                    curso: curso['curso']?.toString() ?? '',
                    profesor: curso['docente']?.toString() ?? '',
                    facultad: curso['facultad']?.toString() ?? '',
                    alumnos: curso['cantidad'] ?? 0,
                    backgroundColor: statusAsync.when(
                      data: (status) => ref.watch(courseColorProvider(status)),
                      loading: () => const Color(0xfff7f9fb),
                      error: (_, __) => const Color(0xfff7f9fb),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}