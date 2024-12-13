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
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 0.5,
          ),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: horarios.map((horario) {
              final isSelected = widget.selectedHorario == horario;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => widget.onHorarioSelected(horario),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? const Color(0xFF9E9E9E)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xff545f70).withOpacity(0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          horario,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            height: 1.2,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xff545f70)
                                : const Color(0xff545f70).withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}