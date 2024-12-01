import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/pages/postpone/curso_card.dart';
import '../../../controllers/postpone_controller.dart';
import 'course_detail_sheet.dart';

class CursoListPostpone extends ConsumerWidget {
  const CursoListPostpone({super.key});

  void _showCourseDetails(
      BuildContext context, {
        required String idCurso,
        required String fecha,
        required String hora,
        required String aula,
        required String cursoNombre,
        required String profesor,
        required String facultad,
        required String numseccion,
        required int alumnos,
        required String estado,
        required String observacion,
      }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      isScrollControlled: true,
      builder: (context) => CourseDetailSheet(
        idCurso: idCurso,
        fecha: fecha,
        hora: hora,
        aula: aula,
        cursoNombre: cursoNombre,
        numseccion: numseccion,
        profesor: profesor,
        facultad: facultad,

        alumnos: alumnos,
        estado: estado,
        observacion: observacion,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const paddingVertical = 10.0;
    final postponedClasses = ref.watch(postponeListProvider);

    return Container(
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          return await ref.read(postponeListProvider.notifier).refresh();
        },
        child: postponedClasses.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
          data: (cursos) => ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: cursos.length,
            itemBuilder: (context, index) {
              final curso = cursos[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: paddingVertical),
                child: GestureDetector(
                  onTap: () => _showCourseDetails(
                    context,
                    idCurso: curso['id'] ?? '',
                    fecha: curso['fecha'] ?? '',
                    hora: curso['hora'] ?? '',
                    aula: curso['aula'] ?? '',
                    cursoNombre: curso['curso'] ?? '',
                    profesor: curso['profesor'] ?? '',
                    facultad: curso['facultad'] ?? '',
                    numseccion: curso['numseccion'] ?? '',
                    alumnos: curso['alumnos'] ?? 0,
                    estado: curso['estado'] ?? '',
                    observacion: curso['observacion'] ?? '',
                  ),
                  child: CursoCard(
                    fecha: curso['fecha'],
                    hora: curso['hora'],
                    aula: curso['aula'],
                    estado: curso['estado'],
                    curso: curso['curso'],
                    profesor: curso['profesor'],
                    alumnos: curso['alumnos'] ?? 0,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}