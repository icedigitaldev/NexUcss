import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardCoordinador extends StatelessWidget {
  final String facultad;
  final String nombre;
  final String telefono;
  final String correo;
  final String imageUrl;

  const CardCoordinador({
    Key? key,
    required this.facultad,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                width: 100, // Puedes ajustar el ancho
                height: 100, // Puedes ajustar la altura
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 100, color: Colors.grey);
                },
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facultad,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xff1c1c1c),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  nombre,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xff1c1c1c),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16.0, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text(
                      telefono,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.email, size: 16.0, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text(
                      correo,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
