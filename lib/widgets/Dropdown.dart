import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const Dropdown({
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174, // Ancho fijo de 174px
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        border: Border.all(color: Colors.grey, width: 1), // Borde gris
        borderRadius: BorderRadius.circular(20), // Bordes redondeados con un radio de 20px
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: DropdownButtonHideUnderline( // Para ocultar la línea por defecto del DropdownButton
          child: DropdownButton<String>(
            value: selectedValue,
            hint: Text(
              'Turno',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.35,
                  fontStyle: FontStyle.normal),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5), // Separación entre el texto y el ícono
              child: Image.asset(
                'assets/images/icon_arrow_down.png',
                width: 20, // Ajusta el tamaño del ícono según tu diseño
              ),
            ),
            iconSize: 24,
            elevation: 16,
            style: GoogleFonts.poppins(
              fontSize: 14, // Fuente Poppins de 14px para los elementos del Dropdown
              color: Colors.black,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.35,
                      fontStyle: FontStyle.normal),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
