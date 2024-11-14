import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexucss/views/home_view.dart';
import 'package:nexucss/views/welcome_view.dart';
import 'package:nexucss/widgets/pages/profile/profile_option.dart';

import 'package:nexucss/views/condition_view.dart';
import 'package:nexucss/views/coordinadores_view.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
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
                'Perfil',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 26),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_image.png'), // Imagen de perfil
            ),
            SizedBox(height: 16),
            Text(
              'Angie Ramires',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff545f70),
              ),
            ),
            SizedBox(height: 36),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Color(0xFFEFF1F4),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ProfileOption(
                    icon: Icons.receipt_long_outlined,
                    title: 'Reportes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(initialIndex: 2),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ProfileOption(
                    icon: Icons.edit_note_outlined,
                    title: 'Aplazados',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(initialIndex: 1),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ProfileOption(
                    icon: Icons.group_outlined,
                    title: 'Coordinadores',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CoordinadoresView()),
                      );
                    },
                  ),
                  Divider(),
                  ProfileOption(
                    icon: Icons.article,
                    title: 'Términos y Condiciones',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConditionView(showBackButton: true),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ProfileOption(
                    icon: Icons.lock_outline,
                    title: 'Cambiar PIN',
                    onTap: () {
                      // Navegar a la página de Cambiar PIN
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFEFF1F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeView(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
