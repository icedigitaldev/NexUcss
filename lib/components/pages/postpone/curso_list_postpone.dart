import 'package:flutter/material.dart';
import '../../../widgets/pages/postpone/curso_card.dart';
import 'course_detail_sheet.dart';

class CursoListPostpone extends StatelessWidget {
  final List<Map<String, dynamic>> cursos = [
    {
      'fecha': '2024-11-15',
      'hora': '08:00 - 09:00',
      'aula': '201',
      'curso': 'AGROTECNIA',
      'profesor': 'CARDOZA SANCHEZ, ALAN MIKE',
      'facultad': 'AGF',
      'alumnos': 19,
      'estado': 'recuperado',
    },
    // Otros cursos...
  ];

  CursoListPostpone({super.key});

  void _showCourseDetails(
      BuildContext context,
      String fecha,
      String hora,
      String aula,
      String cursoNombre,
      String profesor,
      String facultad,
      int alumnos,
      String estado,
      ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      isScrollControlled: true,
      builder: (context) => CourseDetailSheet(
        fecha: fecha,
        hora: hora,
        aula: aula,
        cursoNombre: cursoNombre,
        profesor: profesor,
        facultad: facultad,
        alumnos: alumnos,
        estado: estado,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const paddingVertical = 10.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: paddingVertical),
      child: SingleChildScrollView(
        child: Column(
          children: cursos.map((curso) {
            return Padding(
              padding: const EdgeInsets.only(bottom: paddingVertical),
              child: GestureDetector(
                onTap: () => _showCourseDetails(
                  context,
                  curso['fecha'],
                  curso['hora'],
                  curso['aula'],
                  curso['curso'],
                  curso['profesor'],
                  curso['facultad'],
                  curso['alumnos'],
                  curso['estado'],
                ),
                child: CursoCard(
                  fecha: curso['fecha'],
                  hora: curso['hora'],
                  aula: curso['aula'],
                  estado: curso['estado'],
                  curso: curso['curso'],
                  profesor: curso['profesor'],
                  facultad: curso['facultad'],
                  alumnos: curso['alumnos'],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
