import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CursoCard extends StatelessWidget {
  final String seccion;
  final String aula;
  final String curso;
  final String profesor;
  final String facultad;
  final int alumnos;
  final Color backgroundColor;

  const CursoCard({
    super.key,
    required this.seccion,
    required this.aula,
    required this.curso,
    required this.profesor,
    required this.facultad,
    required this.alumnos,
    this.backgroundColor = const Color(0xfff7f9fb),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
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
                        'Sección: $seccion',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0x661c1c1c),
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
                        'Aula: $aula',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0x661c1c1c),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/icon_fac.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        facultad,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0x661c1c1c),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/icon_alum.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$alumnos',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0x661c1c1c),
                        ),
                      ),
                    ],
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1c1c1c),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                profesor,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff1c1c1c),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}