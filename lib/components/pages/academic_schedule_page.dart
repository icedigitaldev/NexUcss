import 'package:flutter/material.dart';

import 'academic/curso_list.dart';
import '../../widgets/pages/academic/horario_selector.dart';
import '../../widgets/pages/academic/turno_selector.dart';

class AcademicSchedulePage extends StatelessWidget {
  const AcademicSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 0),
        child: Column(
          children: [
            const TurnoSelector(),
            const SizedBox(height: 19),
            const HorarioSelector(),
            const SizedBox(height: 0),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CursoList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
