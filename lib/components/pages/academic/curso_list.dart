import 'package:flutter/material.dart';
import '../../../widgets/pages/academic/curso_card.dart';
import 'add_attendance.dart';

class CursoList extends StatelessWidget {
  final List<Map<String, dynamic>> cursos = [
    {
      'seccion': '285',
      'aula': '201',
      'curso': 'AGROTECNIA',
      'profesor': 'CARDOZA SANCHEZ, ALAN MIKE',
      'facultad': 'AGF',
      'alumnos': 19,
    },
    {
      'seccion': '286',
      'aula': '202',
      'curso': 'BIOLOGÍA',
      'profesor': 'GONZALEZ LOPEZ, JUAN PABLO',
      'facultad': 'BFG',
      'alumnos': 22,
    },
    {
      'seccion': '286',
      'aula': '202',
      'curso': 'BIOLOGÍA',
      'profesor': 'GONZALEZ LOPEZ, JUAN PABLO',
      'facultad': 'BFG',
      'alumnos': 22,
    },
    {
      'seccion': '286',
      'aula': '202',
      'curso': 'BIOLOGÍA',
      'profesor': 'GONZALEZ LOPEZ, JUAN PABLO',
      'facultad': 'BFG',
      'alumnos': 22,
    },
    {
      'seccion': '286',
      'aula': '202',
      'curso': 'BIOLOGÍA',
      'profesor': 'GONZALEZ LOPEZ, JUAN PABLO',
      'facultad': 'BFG',
      'alumnos': 22,
    },
    {
      'seccion': '286',
      'aula': '202',
      'curso': 'BIOLOGÍA',
      'profesor': 'GONZALEZ LOPEZ, JUAN PABLO',
      'facultad': 'BFG',
      'alumnos': 22,
    },
    {
      'seccion': '286',
      'aula': '202',
      'curso': 'BIOLOGÍA',
      'profesor': 'GONZALEZ LOPEZ, JUAN PABLO',
      'facultad': 'BFG',
      'alumnos': 22,
    }, {
      'seccion': '286',
      'aula': '202',
      'curso': 'BIOLOGÍA',
      'profesor': 'GONZALEZ LOPEZ, JUAN PABLO',
      'facultad': 'BFG',
      'alumnos': 22,
    },

  ];

  CursoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(cursos.length, (index) {
            final curso = cursos[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddAttendanceSheet(
                      cursoNombre: curso['curso'] as String,
                      nombreProfe: curso['profesor'] as String,
                      numAula: curso['aula'] as String,
                      nomFacultad: curso['facultad'] as String,
                      canAlumnos: curso['alumnos'],
                      numseccion: curso['seccion'],
                    ),
                  ));
                },
                child: CursoCard(
                  seccion: curso['seccion'],
                  aula: curso['aula'],
                  curso: curso['curso'],
                  profesor: curso['profesor'],
                  facultad: curso['facultad'],
                  alumnos: curso['alumnos'],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
