import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../views/condition_view.dart';
import '../../views/home_view.dart';
import '../../views/welcome_view.dart';
import '../../widgets/pages/profile/profile_option.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.height < 700 ? 0.8 : 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 * scale),
                  child: Column(
                    children: [
                      SizedBox(height: 10 * scale),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 50 * scale,
                              height: 50 * scale,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEef1F4),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF545F71),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Perfil',
                                style: GoogleFonts.poppins(
                                  fontSize: 22 * scale,
                                  color: const Color(0xff545f70),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 50 * scale),
                        ],
                      ),
                      SizedBox(height: 20 * scale),
                      CircleAvatar(
                        radius: 75 * scale,
                        backgroundImage: const AssetImage('assets/images/profile_image.png'),
                      ),
                      SizedBox(height: 16 * scale),
                      Text(
                        'Hola, Bienvenido',
                        style: GoogleFonts.poppins(
                          fontSize: 24 * scale,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff545f70),
                        ),
                      ),
                      SizedBox(height: 26 * scale),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 15 * scale),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF1F4),
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
                                    builder: (context) => const HomeView(initialIndex: 2),
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            ProfileOption(
                              icon: Icons.edit_note_outlined,
                              title: 'Aplazados',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeView(initialIndex: 1),
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            ProfileOption(
                              icon: Icons.play_circle_outline,
                              title: 'Tutorial',
                              onTap: () => Navigator.pushNamed(context, '/tutorial'),
                            ),
                            const Divider(),
                            ProfileOption(
                              icon: Icons.article,
                              title: 'Términos y Condiciones',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ConditionView(showBackButton: true),
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            ProfileOption(
                              icon: Icons.lock_outline,
                              title: 'Cambiar PIN',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeView(),
                      ),
                          (route) => false,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 26,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Cerrar Sesión',
                              style: GoogleFonts.poppins(
                                fontSize: 16 * scale,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}