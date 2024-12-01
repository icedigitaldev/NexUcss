import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Recuperación',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: const Color(0xff545f70),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}