import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class HorarioSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: const Color(0xff9ba5b7), width: 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Text(
                  '07:00 - 08:20',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xff545f70)),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}