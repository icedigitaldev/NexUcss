import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

const primaryColor = Color(0xff545f70);
const secondaryColor = Colors.white;
const shadowColor = Color(0x3f000000);

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool isChecked = false;

  Future<void> _saveTermsAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('terms_accepted', true);
      AppLogger.log('Términos aceptados correctamente', prefix: 'WELCOME:');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/pincode');
      }
    } catch (e) {
      AppLogger.log('Error al guardar términos: $e', prefix: 'ERROR:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Image.asset(
              'assets/images/logo_nexucss.png',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/nexucss.png',
              width: 250,
              height: 46,
            ),
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/condition');
                  },
                  child: const Text(
                    'Términos y condiciones',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 19),
            ElevatedButton(
              onPressed: isChecked ? _saveTermsAndNavigate : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
                backgroundColor: const Color(0xFF545F71),
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Continuar'),
            )
          ],
        ),
      ),
    );
  }
}