import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarAddPostpone extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CalendarAddPostpone({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _CalendarAddPostponeState createState() => _CalendarAddPostponeState();
}

class _CalendarAddPostponeState extends State<CalendarAddPostpone> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            )
        ),
        child: Column(
          children: [
            Expanded(
              child: CalendarDatePicker(
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                onDateChanged: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Cierra el Bottom Sheet
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Color(0xFFD0D5DD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color(0xFFEFEFF4),
                      ),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff545f70),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Espacio de 10px entre los botones
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedDate != null
                          ? () {
                        Navigator.pop(context, selectedDate); // Envía la fecha seleccionada
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: selectedDate != null
                            ? Color(0xFF545F70)
                            : Color(0xFFD3D3D3),
                      ),
                      child: Text(
                        'Hecho',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
