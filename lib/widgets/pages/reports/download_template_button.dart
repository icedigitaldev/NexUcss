import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadTemplateButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DownloadTemplateButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          elevation: 0,
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color(0xFF545F70).withOpacity(0.1);
              }
              return null;
            },
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF545F70).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.download_outlined,
                color: Color(0xFF545F70),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Plantilla',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF545F70),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}