import 'dart:io';
import 'dart:math';
import 'package:excel/excel.dart';
import '../services/excel_service.dart';
import '../utils/logger.dart';

class ExcelController {
  final ExcelService _excelService = ExcelService();

  final Map<String, String> diasSemana = {
    'LUN': 'LUNES',
    'MAR': 'MARTES',
    'MIE': 'MIERCOLES',
    'JUE': 'JUEVES',
    'VIE': 'VIERNES',
    'SAB': 'SABADO',
    'DOM': 'DOMINGO'
  };

  String generateHash() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
        Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  String _getCellValue(Sheet sheet, int row, int col) {
    var cell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: col,
      rowIndex: row,
    ));
    return cell.value?.toString().trim() ?? '';
  }

  bool _isValidRow(Sheet sheet, int rowIndex) {
    var dia = _getCellValue(sheet, rowIndex, 0);
    return dia.isNotEmpty && (diasSemana.containsKey(dia) || diasSemana.containsValue(dia));
  }

  Map<String, dynamic> _processRow(Sheet sheet, int rowIndex) {
    try {
      return {
        'hora': _getCellValue(sheet, rowIndex, 1),      // HORA
        'aula': _getCellValue(sheet, rowIndex, 2),      // AULA
        'curso': _getCellValue(sheet, rowIndex, 3),     // CURSO
        'facultad': _getCellValue(sheet, rowIndex, 4),  // FAC
        'seccion': _getCellValue(sheet, rowIndex, 5),   // SECC.
        'cantidad': int.tryParse(_getCellValue(sheet, rowIndex, 6).replaceAll(RegExp(r'[^0-9]'), '')) ?? 0, // CANT.
        'docente': _getCellValue(sheet, rowIndex, 7),   // DOCENTE
      };
    } catch (e) {
      AppLogger.log('Error procesando fila $rowIndex: $e', prefix: 'EXCEL_CONTROLLER:');
      rethrow;
    }
  }

  Future<void> processExcelFile(File file) async {
    try {
      AppLogger.log('Iniciando procesamiento del archivo Excel', prefix: 'EXCEL_CONTROLLER:');

      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.sheets[excel.sheets.keys.first]!;

      Map<String, Map<String, Map<String, dynamic>>> horariosPorDia = {};

      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        if (!_isValidRow(sheet, rowIndex)) continue;

        var dia = _getCellValue(sheet, rowIndex, 0).toUpperCase();
        String nombreDia = diasSemana[dia] ?? dia;

        try {
          var horarioData = _processRow(sheet, rowIndex);

          // Validar que los datos no estén vacíos
          if (horarioData['hora'].isEmpty ||
              horarioData['curso'].isEmpty ||
              horarioData['facultad'].isEmpty) {
            AppLogger.log('Fila $rowIndex ignorada por datos incompletos', prefix: 'EXCEL_CONTROLLER:');
            continue;
          }

          horariosPorDia.putIfAbsent(nombreDia, () => {});
          String hash = generateHash();
          while (horariosPorDia[nombreDia]!.containsKey(hash)) {
            hash = generateHash();
          }

          horariosPorDia[nombreDia]![hash] = horarioData;

          AppLogger.log('Procesada fila $rowIndex para $nombreDia', prefix: 'EXCEL_CONTROLLER:');
        } catch (e) {
          AppLogger.log('Error procesando fila $rowIndex: $e', prefix: 'EXCEL_CONTROLLER:');
          continue;
        }
      }

      if (horariosPorDia.isEmpty) {
        throw Exception('No se encontraron datos válidos para procesar');
      }

      await _excelService.uploadHorariosToFirestore(horariosPorDia);

      AppLogger.log('Proceso completado exitosamente', prefix: 'EXCEL_CONTROLLER:');
    } catch (e) {
      AppLogger.log('Error al procesar el archivo Excel: $e', prefix: 'EXCEL_CONTROLLER:');
      rethrow;
    }
  }

  Future<void> validateExcelFile(File file) async {
    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      if (excel.sheets.isEmpty) {
        throw Exception('El archivo Excel no contiene hojas de cálculo');
      }

      var sheet = excel.sheets[excel.sheets.keys.first]!;
      if (sheet.maxRows < 2) {
        throw Exception('El archivo Excel no contiene datos suficientes');
      }

      // Validar encabezados
      final expectedHeaders = ['DIA', 'HORA', 'AULA', 'CURSO', 'FAC', 'SECC.', 'CANT.', 'DOCENTE'];
      for (int i = 0; i < expectedHeaders.length; i++) {
        var headerValue = _getCellValue(sheet, 0, i).toUpperCase();
        if (!headerValue.contains(expectedHeaders[i])) {
          throw Exception('El formato del archivo no coincide con el esperado. Columna ${i + 1} incorrecta');
        }
      }

      AppLogger.log('Archivo Excel validado correctamente', prefix: 'EXCEL_CONTROLLER:');
    } catch (e) {
      AppLogger.log('Error en la validación del archivo Excel: $e', prefix: 'EXCEL_CONTROLLER:');
      rethrow;
    }
  }
}