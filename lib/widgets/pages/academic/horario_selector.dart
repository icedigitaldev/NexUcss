import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorarioSelector extends StatefulWidget {
  final String turno;
  final String? selectedHorario;
  final Function(String) onHorarioSelected;

  const HorarioSelector({
    super.key,
    required this.turno,
    required this.onHorarioSelected,
    this.selectedHorario,
  });

  @override
  State<HorarioSelector> createState() => _HorarioSelectorState();
}

class _HorarioSelectorState extends State<HorarioSelector> {
  @override
  void initState() {
    super.initState();
    if (widget.selectedHorario == null) {
      final horarios = getHorariosByTurno();
      if (horarios.isNotEmpty) {
        Future.microtask(() {
          if (mounted) {
            widget.onHorarioSelected(horarios.first);
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(HorarioSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.turno != widget.turno) {
      final horarios = getHorariosByTurno();
      if (horarios.isNotEmpty) {
        Future.microtask(() {
          if (mounted) {
            widget.onHorarioSelected(horarios.first);
          }
        });
      }
    }
  }

  List<String> getHorariosByTurno() {
    switch (widget.turno) {
      case 'Mañana':
        return ['07:00-08:20', '08:30-10:00', '10:15-11:45'];
      case 'Tarde':
        return ['12:00-13:30','14:00-15:30', '15:45-17:15'];
      case 'Noche':
        return ['17:30-19:00','19:10-20:40', '20:50-22:20'];
      default:
        return ['07:00-08:20', '08:30-10:00', '10:15-11:45'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final horarios = getHorariosByTurno();

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xff9ba5b7), width: 2))
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            const SizedBox(width: 4),
            ...horarios.map((horario) {
              final isSelected = widget.selectedHorario == horario;
              return GestureDetector(
                onTap: () => widget.onHorarioSelected(horario),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff545f70) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    horario,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: isSelected ? Colors.white : const Color(0xff545f70),
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}