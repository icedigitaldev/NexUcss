import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dropdown.dart';

class TurnoSelector extends StatefulWidget {
  final Function(String) onTurnoChanged;
  const TurnoSelector({super.key, required this.onTurnoChanged});

  @override
  State<TurnoSelector> createState() => _TurnoSelectorState();
}

class _TurnoSelectorState extends State<TurnoSelector> {
  final List<String> items = ['Mañana', 'Tarde', 'Noche'];
  late String selectedValue;
  String formattedDate = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedValue = items.first;
    _initializeDate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTurnoChanged(selectedValue);
    });
  }

  Future<void> _initializeDate() async {
    Intl.defaultLocale = 'es';
    await initializeDateFormatting('es');
    if (mounted) {
      setState(() {
        formattedDate = _getFormattedDate(selectedDate);
      });
    }
  }

  String _getFormattedDate(DateTime date) {
    final formatted = DateFormat('EEEE dd/MM/yy', 'es').format(date);
    final parts = formatted.split(' ');
    return '${parts[0].capitalize()} ${parts[1]}';
  }

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Container(
        height: 380,
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
            ),
          ),
          child: CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
                formattedDate = _getFormattedDate(date);
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xff9ba5b7),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _showDatePicker,
                child: Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.36,
                  ),
                ),
              ),
              Dropdown(
                selectedValue: selectedValue,
                items: items,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedValue = value);
                    widget.onTurnoChanged(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}