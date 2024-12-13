import 'package:flutter/material.dart';
import 'academic/curso_list.dart';
import '../../widgets/pages/academic/horario_selector.dart';
import '../../widgets/pages/academic/turno_selector.dart';

class AcademicSchedulePage extends StatefulWidget {
  const AcademicSchedulePage({super.key});

  @override
  State<AcademicSchedulePage> createState() => _AcademicSchedulePageState();
}

class _AcademicSchedulePageState extends State<AcademicSchedulePage> {
  String selectedTurno = 'Mañana';
  String? selectedHorario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TurnoSelector(
              onTurnoChanged: (turno) {
                setState(() {
                  selectedTurno = turno;
                  selectedHorario = null;
                });
              },
            ),
            const SizedBox(height: 12),
            HorarioSelector(
              turno: selectedTurno,
              selectedHorario: selectedHorario,
              onHorarioSelected: (horario) {
                setState(() {
                  selectedHorario = horario;
                });
              },
            ),
            const SizedBox(height: 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: CursoList(selectedHorario: selectedHorario),
              ),
            ),
          ],
        ),
      ),
    );
  }
}