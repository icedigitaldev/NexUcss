import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dropdown.dart';

class TurnoSelector extends StatefulWidget {
  final Function(String) onTurnoChanged;

  const TurnoSelector({super.key, required this.onTurnoChanged});

  @override
  _TurnoSelectorState createState() => _TurnoSelectorState();
}

class _TurnoSelectorState extends State<TurnoSelector> {
  List<String> items = [
    'Mañana',
    'Tarde',
    'Noche',
  ];

  String? selectedValue;
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    selectedValue = 'Mañana';
    _initializeDate();
    Future.microtask(() {
      if (mounted) {
        widget.onTurnoChanged(selectedValue!);
      }
    });
  }

  Future<void> _initializeDate() async {
    await initializeDateFormatting('es_ES', null);
    if (mounted) {
      setState(() {
        formattedDate = _getFormattedDate();
      });
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE dd/MM/yy', 'es_ES');
    String formatted = formatter.format(now);
    String dayName = formatted.split(' ')[0];
    dayName = dayName[0].toUpperCase() + dayName.substring(1);
    return '$dayName ${formatted.split(' ')[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xff9ba5b7),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.36,
                ),
              ),
              Dropdown(
                selectedValue: selectedValue,
                items: items,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue;
                    widget.onTurnoChanged(newValue!);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}