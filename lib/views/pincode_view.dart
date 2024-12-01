import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/pincode_controller.dart';
import '../utils/logger.dart';

class PincodeView extends StatefulWidget {
  const PincodeView({super.key});

  @override
  State<PincodeView> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PincodeView> {
  final PincodeController _controller = PincodeController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _handlePinValidation() async {
    if (_controller.enteredPin.length == 4) {
      _controller.setLoading(true, setState);
      try {
        final result = await _controller.validatePin();

        if (result['isValid']) {
          AppLogger.log('PIN válido', prefix: 'PIN:');
          Navigator.pushNamed(context, '/home');
        } else {
          _showErrorMessage(result['message']);
          _controller.clearPin(setState);
        }
      } catch (e) {
        _showErrorMessage('Error al validar el PIN');
      } finally {
        _controller.setLoading(false, setState);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _launchEmailClient() async {
    final subject = Uri.encodeComponent('Solicitud de nuevo PIN');
    final body = Uri.encodeComponent('Hola,\n\nSolicito la generación de un nuevo PIN para mi cuenta.\n\nGracias.');

    final Uri emailLaunchUri = Uri.parse(
        'mailto:support@icedigital.pe?subject=$subject&body=$body'
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'No se pudo abrir el cliente de correo';
      }
    } catch (e) {
      _showErrorMessage('Error al abrir el cliente de correo');
    }
  }

  Widget gridView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 50.0,
        children: [
          keyField("1"), keyField("2"), keyField("3"),
          keyField("4"), keyField("5"), keyField("6"),
          keyField("7"), keyField("8"), keyField("9"),
          fingerprint(),
          keyField("0"), backSpace(),
        ],
      ),
    );
  }

  Widget keyField(String numb) {
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            _controller.onNumberTapped(numb, setState);
            _handlePinValidation();
          },
          child: Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffa4ecdb), width: 1),
            ),
            child: Center(
              child: Text(
                numb,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xee114052),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fingerprint() {
    return Container(
      height: 66,
      width: 66,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.fingerprint,
        color: Colors.black,
        size: 50,
      ),
    );
  }

  Widget backSpace() {
    return IconButton(
      onPressed: () => _controller.onCancelText(setState),
      icon: const Icon(
        Icons.backspace,
        color: Colors.black,
        size: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(top: 50),
              physics: const BouncingScrollPhysics(),
              children: [
                Image.asset(
                  'assets/images/nexucss.png',
                  width: 200,
                  height: 46,
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    'Hola, ingresa tu PIN',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: index < _controller.enteredPin.length
                            ? Colors.cyan
                            : Colors.transparent,
                        border: Border.all(
                          color: Colors.cyan,
                          width: 1.5,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Visibility(
                  visible: _controller.isLoading,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: const SizedBox(
                    height: 43,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                gridView(),
                const SizedBox(height: 68),
                Center(
                  child: GestureDetector(
                    onTap: _launchEmailClient,
                    child: Text(
                      '¿Olvidaste tu PIN?',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}