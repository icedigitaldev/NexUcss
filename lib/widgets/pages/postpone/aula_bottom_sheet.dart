import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AulaBottomSheet extends StatelessWidget {
  final List<Map<String, String>> aulasHorarios;
  final ValueChanged<Map<String, String>> onAulaSelected;

  const AulaBottomSheet({
    Key? key,
    required this.aulasHorarios,
    required this.onAulaSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona un aula',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: aulasHorarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    onAulaSelected(aulasHorarios[index]);
                    Navigator.of(context).pop(); // Cierra el BottomSheet
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        aulasHorarios[index]['horario']!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        aulasHorarios[index]['aula']!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
