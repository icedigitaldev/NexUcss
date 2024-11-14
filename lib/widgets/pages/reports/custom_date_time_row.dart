import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDateTimeRow extends StatelessWidget {
  final String imagePath;
  final String dateText;
  final String timeText;

  const CustomDateTimeRow({
    Key? key,
    required this.imagePath,
    required this.dateText,
    required this.timeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFEFF1F4),
              borderRadius: BorderRadius.circular(100), // Borde redondeado circular de 100
            ),
            padding: EdgeInsets.all(12), // Espacio interno para la imagen
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
          ),
          Text(
            dateText,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Color(0xff545f70),
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            timeText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xff545f70),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
