import 'dart:io';
import 'package:flutter/services.dart';
import '../utils/logger.dart';

class TemplateDownloadController {
  Future<String> downloadTemplate() async {
    try {
      final ByteData data = await rootBundle.load('assets/data/excel_template.xlsx');
      final List<int> bytes = data.buffer.asUint8List();

      final dir = Directory('/storage/emulated/0/Documents/plantillas');
      AppLogger.log('Verificando directorio: ${dir.path}');

      if (!await dir.exists()) {
        await dir.create(recursive: true);
        AppLogger.log('Directorio creado');
      }

      final filePath = '${dir.path}/plantilla_excel.xlsx';
      AppLogger.log('Ruta archivo: $filePath');

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);

      AppLogger.log('Plantilla guardada: $filePath');
      return filePath;

    } catch (e) {
      AppLogger.log('Error al descargar plantilla: $e', prefix: 'ERROR:');
      throw Exception('Error al descargar la plantilla');
    }
  }
}