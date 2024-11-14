import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownPostpone extends StatelessWidget {
  final String title;
  final List<String> items;
  final String hint;
  final Function(String?) onChanged;

  const DropdownPostpone({
    Key? key,
    required this.title,
    required this.items,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth, // Define el ancho máximo del contenedor
              child: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
                hint: Text(
                  hint,
                  style: const TextStyle(color: Colors.black),
                ),
                items: items.map(
                      (location) => DropdownMenuItem(
                    value: location,
                    child: Text(
                      location,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ).toList(),
                onChanged: onChanged,
                isExpanded: true, // Expande el dropdown dentro de los límites del contenedor padre
              ),
            );
          },
        ),
      ],
    );
  }
}
