import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CursoCard extends StatelessWidget {
  final String fecha;
  final String hora;
  final String aula;
  final String estado;
  final String curso;
  final String profesor;
  final int alumnos;

  const CursoCard({super.key,
    required this.fecha,
    required this.hora,
    required this.aula,
    required this.estado,
    required this.curso,
    required this.profesor,
    required this.alumnos,
  });

  @override
  Widget build(BuildContext context) {
    Color estadoColor;
    switch (estado.toLowerCase()) {
      case 'pendiente':
        estadoColor = const Color(0xff565471);
        break;
      case 'cancelada':
        estadoColor = const Color(0xffc10c0c);
        break;
      case 'recuperada':
        estadoColor = const Color(0xff118615);
        break;
      default:
        estadoColor = const Color(0xffe5ecf6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xfff7f9fb),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x3f000000), offset: Offset(0, 0), blurRadius: 4),],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffe5ecf6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        'Fecha: $fecha',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff545f71),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffe5ecf6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        'Hora: $hora',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff545f71),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                curso,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1c1c1c),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                profesor,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff1c1c1c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffe5ecf6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Aula: $aula',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff545f71),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: estadoColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    estado[0].toUpperCase() + estado.substring(1).toLowerCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffe5ecf6),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}