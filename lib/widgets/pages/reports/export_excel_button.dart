import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExportExcelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ExportExcelButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff545f70),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Exportar Excel',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Image.asset(
              'assets/images/excelDown.png',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
