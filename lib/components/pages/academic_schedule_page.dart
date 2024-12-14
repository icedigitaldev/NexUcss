import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'academic/curso_list.dart';
import '../../widgets/pages/academic/horario_selector.dart';
import '../../widgets/pages/academic/turno_selector.dart';
import '../../utils/logger.dart';

class AcademicSchedulePage extends ConsumerStatefulWidget {
  const AcademicSchedulePage({super.key});

  @override
  ConsumerState<AcademicSchedulePage> createState() => _AcademicSchedulePageState();
}

class _AcademicSchedulePageState extends ConsumerState<AcademicSchedulePage> {
  String selectedTurno = 'Mañana';
  String? selectedHorario;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    AppLogger.log('Inicializando AcademicSchedulePage', prefix: 'ACADEMIC:');
  }

  void _handleTurnoChanged(String turno) {
    setState(() {
      selectedTurno = turno;
      selectedHorario = null;
    });
    AppLogger.log('Turno seleccionado: $turno', prefix: 'ACADEMIC:');
  }

  void _handleDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    AppLogger.log('Fecha seleccionada: $date', prefix: 'ACADEMIC:');
  }

  void _handleHorarioSelected(String horario) {
    setState(() {
      selectedHorario = horario;
    });
    AppLogger.log('Horario seleccionado: $horario', prefix: 'ACADEMIC:');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            TurnoSelector(
              onTurnoChanged: _handleTurnoChanged,
              onDateChanged: _handleDateChanged,
            ),
            const SizedBox(height: 12),
            HorarioSelector(
              turno: selectedTurno,
              selectedHorario: selectedHorario,
              onHorarioSelected: _handleHorarioSelected,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: CursoList(
                  selectedHorario: selectedHorario,
                  selectedDate: selectedDate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    AppLogger.log('Disposing AcademicSchedulePage', prefix: 'ACADEMIC:');
    super.dispose();
  }
}