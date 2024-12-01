import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/pages/coordinadores/list_card_coordinadores.dart';

class CoordinadoresView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              scrolledUnderElevation: 0,
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
                'Coordinadores',
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
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: ListCardCoordinadores(),
        ),
      )
    );
  }
}
