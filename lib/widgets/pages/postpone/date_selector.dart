import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DateSelector({
    Key? key,
    required this.selectedDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de Recuperación',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
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
                  selectedDate != null
                      ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
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
      ],
    );
  }
}