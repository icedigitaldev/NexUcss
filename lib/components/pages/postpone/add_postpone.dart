import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexucss/widgets/pages/academic/curso_card.dart';
import 'package:nexucss/widgets/pages/postpone/calendar_add_postpone.dart';
import 'package:nexucss/widgets/pages/postpone/aula_bottom_sheet.dart'; // Importa el nuevo widget

import '../../../views/home_view.dart';
import '../postpone_schedules_page.dart';

class AddPostpone extends StatefulWidget {
  final String cursoNombre;
  final String nombreProfe;
  final String nomFacultad;
  final String numAula;
  final int canAlumnos;
  final String numseccion;

  const AddPostpone({
    super.key,
    required this.cursoNombre,
    required this.nombreProfe,
    required this.nomFacultad,
    required this.numAula,
    required this.canAlumnos,
    required this.numseccion,
  });

  @override
  State<StatefulWidget> createState() => _AddPostpone();
}

class _AddPostpone extends State<AddPostpone> {
  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedDate;
  String? _selectedAula;

  // Lista de aulas y horarios combinados en mapas
  List<Map<String, String>> aulasHorarios = [
    {'horario': '08:00 - 09:00', 'aula': 'Aula 101'},
    {'horario': '08:30 - 09:50', 'aula': 'Aula 102'},
    {'horario': '10:00 - 11:20', 'aula': 'Aula 103'},
    {'horario': '11:30 - 12:50', 'aula': 'Aula 104'},
  ];

  void _openCalendarBottomSheet(BuildContext context) async {
    final DateTime? selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CalendarAddPostpone(
          onDateSelected: (DateTime date) {
            Navigator.pop(context, date); // Envía la fecha seleccionada al cerrar el BottomSheet
          },
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate; // Actualiza la fecha seleccionada
      });
    }
  }

  void _openAulaBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (BuildContext context) {
        return AulaBottomSheet(
          aulasHorarios: aulasHorarios,
          onAulaSelected: (Map<String, String> aulaSeleccionada) {
            setState(() {
              _selectedAula = aulaSeleccionada['aula'];
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEef1F4),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF545F71),
                      size: 20,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Recuperación',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xff545f70),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clase a Recuperar',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff545f70),
                ),
              ),
              const SizedBox(height: 8),
              CursoCard(
                seccion: widget.numseccion,
                aula: widget.numAula,
                curso: widget.cursoNombre,
                profesor: widget.nombreProfe,
                facultad: widget.nomFacultad,
                alumnos: widget.canAlumnos,
              ),
              const SizedBox(height: 26),
              Text(
                'Programación',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff545f70),
                ),
              ),
              const SizedBox(height: 13),
              Text(
                'Fecha de Recuperación',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openCalendarBottomSheet(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xffd3d3d3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}"
                            : 'Seleccionar fecha',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Seleccionar aula',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openAulaBottomSheet(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xffd3d3d3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedAula ?? 'Seleccionar aula',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Retorna falso si se cancela
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xfff1f3f5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xff545f70),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeView(initialIndex: 1), // Cambia el índice inicial
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff545f70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Continuar',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
