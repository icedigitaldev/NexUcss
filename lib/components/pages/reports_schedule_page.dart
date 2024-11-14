import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexucss/components/pages/reports/ListDateTime.dart';
import 'package:nexucss/widgets/pages/reports/date_picker_bottom_sheet.dart';
import 'package:nexucss/widgets/pages/reports/import_excel_button.dart';
import 'package:nexucss/widgets/pages/reports/export_excel_button.dart';

class ReportsSchedulePage extends StatefulWidget {
  const ReportsSchedulePage({super.key});

  @override
  _ReportsSchedulePageState createState() => _ReportsSchedulePageState();
}

class _ReportsSchedulePageState extends State<ReportsSchedulePage> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      print("Archivo seleccionado: ${result.files.single.name}");
    } else {
      print("No se seleccionó ningún archivo");
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DatePickerBottomSheet(
          initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate;
        } else {
          endDate = selectedDate;
        }
      });
    }
  }

  Widget _buildDatePicker(String label, bool isStartDate) {
    DateTime? selectedDate = isStartDate ? startDate : endDate;
    String displayText = selectedDate != null
        ? "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}"
        : label;

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(context, isStartDate),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFCBD5E0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFF7A869A),
                ),
              ),
              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF7A869A),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeData = [
      {
        'imagePath': 'assets/images/excelDownDarck.png',
        'dateText': 'Jueves, 13-10-2024',
        'timeText': '08:00 pm',
      },
      {
        'imagePath': 'assets/images/excelDownDarck.png',
        'dateText': 'Viernes, 14-10-2024',
        'timeText': '09:00 am',
      },
      {
        'imagePath': 'assets/images/excelDownDarck.png',
        'dateText': 'Viernes, 14-10-2024',
        'timeText': '09:00 am',
      },
      {
        'imagePath': 'assets/images/excelDownDarck.png',
        'dateText': 'Viernes, 14-10-2024',
        'timeText': '09:00 am',
      }
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImportExcelButton(onPressed: _pickFile), // Usa el widget ImportExcelButton
              SizedBox(height: 36),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Generar Reporte',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff545f70),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Rango de fecha',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xff545f70),
                ),
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  _buildDatePicker("DD/MM/AAAA", true),
                  SizedBox(width: 10),
                  _buildDatePicker("DD/MM/AAAA", false),
                ],
              ),
              SizedBox(height: 26),
              ExportExcelButton(onPressed: () {}), // Usa el widget ExportExcelButton
              SizedBox(height: 46),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Historial de Reportes',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff545f70),
                  ),
                ),
              ),
              Expanded(
                child: ListDateTime(dateTimeData: dateTimeData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
