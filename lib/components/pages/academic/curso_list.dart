import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/curso_controller.dart';
import '../../../controllers/course_status_controller.dart';
import '../../../widgets/pages/academic/curso_card.dart';
import 'add_attendance.dart';

class CursoList extends ConsumerWidget {
  final String? selectedHorario;

  const CursoList({
    super.key,
    this.selectedHorario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursosAsync = ref.watch(cursoControllerProvider);
    final searchQuery = ref.watch(searchControllerProvider).query;
    return cursosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (_) {
        final cursos = ref.watch(cursosFiltradosPorHoraProvider(selectedHorario));

        if (cursos.isEmpty) {
          return Center(
            child: Text(searchQuery.isEmpty
                ? 'No hay cursos disponibles en este horario'
                : 'No se encontraron resultados para "$searchQuery"'
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () async {
              return await ref.read(cursoControllerProvider.notifier).refresh();
            },
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(cursos.length, (index) {
                  final curso = cursos[index];
                  final idCurso = curso['id_curso']?.toString() ?? '';
                  final statusAsync = ref.watch(courseStatusProvider(idCurso));

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
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
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}