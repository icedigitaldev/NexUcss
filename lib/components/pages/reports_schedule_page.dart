import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/report_download_controller.dart';
import '../../controllers/template_download_controller.dart';
import '../../widgets/pages/reports/date_picker_bottom_sheet.dart';
import '../../widgets/pages/reports/export_excel_button.dart';
import '../../widgets/pages/reports/import_excel_button.dart';
import '../../widgets/pages/reports/download_template_button.dart';
import '../../controllers/excel_controller.dart';
import '../../controllers/history_controller.dart';
import '../../utils/logger.dart';
import 'reports/list_date_time.dart';

class ReportsSchedulePage extends StatefulWidget {
  const ReportsSchedulePage({super.key});

  @override
  _ReportsSchedulePageState createState() => _ReportsSchedulePageState();
}

class _ReportsSchedulePageState extends State<ReportsSchedulePage> {
  DateTime? startDate;
  DateTime? endDate;
  final ExcelController _excelController = ExcelController();
  final HistoryController _historyController = HistoryController();
  final ReportDownloadController _reportDownloadController = ReportDownloadController();
  bool _isProcessing = false;
  bool _isDownloadingTemplate = false;

  List<Map<String, String>> _convertToStringMap(List<Map<String, dynamic>> dynamicList) {
    return dynamicList.map((item) => {
      'dateText': item['dateText']?.toString() ?? '',
      'timeText': item['timeText']?.toString() ?? '',
      'status': item['status']?.toString() ?? '',
      'userName': item['userName']?.toString() ?? '',
    }).toList();
  }

  Future<void> _pickFile() async {
    try {
      setState(() => _isProcessing = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        AppLogger.log('Procesando archivo: ${result.files.single.name}', prefix: 'EXCEL:');

        await _excelController.processExcelFile(file);
        await _historyController.registerUpload();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Excel procesado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      AppLogger.log('Error al procesar Excel: $e', prefix: 'ERROR:');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar el archivo Excel'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DownloadTemplateButton(
                        onPressed: () {
                          final templateController = TemplateDownloadController();
                          templateController.downloadTemplate().then((filePath) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Plantilla descargada en: $filePath'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al descargar la plantilla'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ImportExcelButton(
                          onPressed: _isProcessing ? () {} : () {
                            _pickFile();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Generar Reporte',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff545f70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rango de fecha',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xff545f70),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      _buildDatePicker("DD/MM/AAAA", true),
                      const SizedBox(width: 10),
                      _buildDatePicker("DD/MM/AAAA", false),
                    ],
                  ),
                  const SizedBox(height: 26),
                  ExportExcelButton(
                      onPressed: () async {
                        if (startDate == null || endDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Seleccione un rango de fechas'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        try {
                          setState(() => _isProcessing = true);

                          await _reportDownloadController.registerDownload(startDate!, endDate!);
                          await _historyController.registerDownload();

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reporte generado correctamente'))
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al generar el reporte'),
                                backgroundColor: Colors.red,
                              )
                          );
                        } finally {
                          if (mounted) setState(() => _isProcessing = false);
                        }
                      }
                  ),
                  const SizedBox(height: 36),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historial de Reportes',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff545f70),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _historyController.getHistoryStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Error al cargar el historial'));
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final historyData = _convertToStringMap(snapshot.data ?? []);
                        return ListDateTime(dateTimeData: historyData);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xff545f70),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Procesando Excel...',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
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
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF7A869A),
                ),
              ),
              const Icon(
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

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      shape: const RoundedRectangleBorder(
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
}