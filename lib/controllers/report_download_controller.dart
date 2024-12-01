import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import '../services/report_download_service.dart';
import '../utils/logger.dart';

class ReportDownloadController {
  final ReportDownloadService _service = ReportDownloadService();

  Future<void> registerDownload(DateTime startDate, DateTime endDate) async {
    try {
      AppLogger.log('Iniciando descarga de reporte');
      final asistencias = await _service.getAsistencias(startDate, endDate);
      AppLogger.log('Asistencias obtenidas: ${asistencias.length}');

      final postpones = await _service.getPostpones(startDate, endDate);
      AppLogger.log('Postergaciones obtenidas: ${postpones.length}');

      final Workbook workbook = Workbook();

      final Worksheet asistenciasSheet = workbook.worksheets[0];
      asistenciasSheet.name = 'Asistencias';

      final Worksheet pospuestasSheet = workbook.worksheets.add();
      pospuestasSheet.name = 'Pospuestas';

      _addHeadersToAsistencias(asistenciasSheet);
      _addHeadersToPospuestas(pospuestasSheet);

      _fillAsistenciasData(asistenciasSheet, asistencias);
      _fillPospuestasData(pospuestasSheet, postpones);

      _adjustColumnWidths(asistenciasSheet, pospuestasSheet);

      AppLogger.log('Intentando guardar Excel');
      await _saveExcel(workbook);
      AppLogger.log('Excel guardado exitosamente');

      workbook.dispose();
    } catch (e) {
      AppLogger.log('Error en registerDownload: $e');
      throw Exception('Error generando reporte: $e');
    }
  }

  void _adjustColumnWidths(Worksheet asistenciasSheet, Worksheet pospuestasSheet) {
    final asistenciasWidths = [15.0, 12.0, 25.0, 15.0, 15.0, 20.0, 20.0, 30.0];
    final pospuestasWidths = [15.0, 15.0, 25.0, 25.0, 15.0, 15.0, 15.0];

    for (int i = 0; i < asistenciasWidths.length; i++) {
      asistenciasSheet.getRangeByIndex(1, i + 1).columnWidth = asistenciasWidths[i];
    }

    for (int i = 0; i < pospuestasWidths.length; i++) {
      pospuestasSheet.getRangeByIndex(1, i + 1).columnWidth = pospuestasWidths[i];
    }
  }

  void _addHeadersToAsistencias(Worksheet sheet) {
    AppLogger.log('Agregando headers asistencias');
    final headers = [
      'Fecha', 'Hora', 'Profesor', 'Sección', 'Estado',
      'Ubicación', 'Usuario', 'Observación'
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(1, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.hAlign = HAlignType.center;
    }
  }

  void _addHeadersToPospuestas(Worksheet sheet) {
    AppLogger.log('Agregando headers postergaciones');
    final headers = [
      'Fecha', 'Horario', 'Curso', 'Profesor',
      'Sección', 'Aula', 'Estado'
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(1, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.hAlign = HAlignType.center;
    }
  }

  void _fillAsistenciasData(Worksheet sheet, List<Map<String, dynamic>> asistencias) {
    AppLogger.log('Llenando datos asistencias');
    int row = 2;

    for (var asistencia in asistencias) {
      var fecha = DateTime.parse(asistencia['hora'].toDate().toString());

      sheet.getRangeByIndex(row, 1).setText(fecha.toString().split(' ')[0]);
      sheet.getRangeByIndex(row, 2).setText(fecha.toString().split(' ')[1]);
      sheet.getRangeByIndex(row, 3).setText(asistencia['profesor']);
      sheet.getRangeByIndex(row, 4).setText(asistencia['seccion']);
      sheet.getRangeByIndex(row, 5).setText(asistencia['estado']);
      sheet.getRangeByIndex(row, 6).setText(asistencia['ubicacion']);
      sheet.getRangeByIndex(row, 7).setText(asistencia['usuario']);
      sheet.getRangeByIndex(row, 8).setText(asistencia['observacion'] ?? '');

      row++;
    }
    AppLogger.log('Datos asistencias completados');
  }

  void _fillPospuestasData(Worksheet sheet, List<Map<String, dynamic>> postpones) {
    AppLogger.log('Llenando datos postergaciones');
    int row = 2;

    for (var postpone in postpones) {
      var fecha = DateTime.parse(postpone['fecha'].toDate().toString());

      sheet.getRangeByIndex(row, 1).setText(fecha.toString().split(' ')[0]);
      sheet.getRangeByIndex(row, 2).setText(postpone['horario']);
      sheet.getRangeByIndex(row, 3).setText(postpone['curso_nombre']);
      sheet.getRangeByIndex(row, 4).setText(postpone['profesor_nombre']);
      sheet.getRangeByIndex(row, 5).setText(postpone['seccion']);
      sheet.getRangeByIndex(row, 6).setText(postpone['aula']);
      sheet.getRangeByIndex(row, 7).setText(postpone['estado']);

      row++;
    }
    AppLogger.log('Datos postergaciones completados');
  }

  Future<void> _saveExcel(Workbook workbook) async {
    try {
      final dir = Directory('/storage/emulated/0/Documents/reportes');
      AppLogger.log('Verificando directorio: ${dir.path}');

      if (!await dir.exists()) {
        await dir.create(recursive: true);
        AppLogger.log('Directorio creado');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${dir.path}/reporte_$timestamp.xlsx';
      AppLogger.log('Ruta archivo: $filePath');

      final List<int> bytes = workbook.saveAsStream();
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);

      AppLogger.log('Archivo guardado: $filePath');
    } catch (e) {
      AppLogger.log('Error guardando Excel: $e');
      throw Exception('Error guardando archivo Excel: $e');
    }
  }
}