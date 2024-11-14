import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Color(0xff545f70),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Color(0xff545f70),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Color(0xff545f70),
        size: 16,
      ),
      onTap: onTap, // Ejecuta la función onTap pasada como parámetro
    );
  }
}
