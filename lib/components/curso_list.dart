import 'package:flutter/material.dart';
import '../widgets/curso_card.dart'; // Importa `CursoCard`

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
  ];

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
              child: CursoCard(
                seccion: curso['seccion'],
                aula: curso['aula'],
                curso: curso['curso'],
                profesor: curso['profesor'],
                facultad: curso['facultad'],
                alumnos: curso['alumnos'],
              ),
            );
          }),
        ),
      ),
    );
  }
}
