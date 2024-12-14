import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../utils/logger.dart';
import 'dropdown.dart';

class TurnoSelector extends StatefulWidget {
  final Function(String) onTurnoChanged;
  final Function(DateTime) onDateChanged;

  const TurnoSelector({
    super.key,
    required this.onTurnoChanged,
    required this.onDateChanged,
  });

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
      widget.onDateChanged(selectedDate);
    });
    AppLogger.log('TurnoSelector inicializado', prefix: 'TURNO_SELECTOR:');
  }

  Future<void> _initializeDate() async {
    try {
      Intl.defaultLocale = 'es';
      await initializeDateFormatting('es');
      if (mounted) {
        setState(() {
          formattedDate = _getFormattedDate(selectedDate);
        });
      }
      AppLogger.log('Fecha inicializada: $formattedDate', prefix: 'TURNO_SELECTOR:');
    } catch (e) {
      AppLogger.log('Error al inicializar fecha: $e', prefix: 'TURNO_SELECTOR:');
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
            // Establecer la fecha inicial al primer día del año actual
            firstDate: DateTime(DateTime.now().year, 1, 1),
            // Establecer la fecha final al último día del año actual
            lastDate: DateTime(DateTime.now().year, 12, 31),
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
                formattedDate = _getFormattedDate(date);
              });
              widget.onDateChanged(date);
              AppLogger.log('Nueva fecha seleccionada: $formattedDate', prefix: 'TURNO_SELECTOR:');
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
              Expanded(
                child: GestureDetector(
                  onTap: _showDatePicker,
                  child: Text(
                    formattedDate,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.36,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                    AppLogger.log('Nuevo turno seleccionado: $value', prefix: 'TURNO_SELECTOR:');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    AppLogger.log('Disposing TurnoSelector', prefix: 'TURNO_SELECTOR:');
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}