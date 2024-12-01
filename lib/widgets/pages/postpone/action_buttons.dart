import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onContinue;
  final bool isLoading;

  const ActionButtons({
    Key? key,
    required this.onCancel,
    required this.onContinue,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: isLoading ? null : onCancel,
            style: TextButton.styleFrom(
              backgroundColor: isLoading
                  ? const Color(0xfff1f3f5).withOpacity(0.7)
                  : const Color(0xfff1f3f5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: isLoading
                    ? const Color(0xff545f70).withOpacity(0.5)
                    : const Color(0xff545f70),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading
                  ? const Color(0xff545f70).withOpacity(0.7)
                  : const Color(0xff545f70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              'Continuar',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}