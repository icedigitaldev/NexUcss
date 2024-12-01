import 'package:intl/intl.dart';
import '../services/history_service.dart';
import '../utils/logger.dart';

class HistoryController {
  final HistoryService _historyService = HistoryService();

  Future<void> registerDownload() async {
    try {
      final now = DateTime.now();
      final dateText = DateFormat('EEEE, dd-MM-yyyy', 'es').format(now);
      final timeText = DateFormat('hh:mm a').format(now);

      await _historyService.addHistoryEntry(
        dateText: dateText,
        timeText: timeText,
        status: 'download',
      );

      AppLogger.log('Descarga registrada', prefix: 'HISTORY:');
    } catch (e) {
      AppLogger.log('Error al registrar descarga: $e', prefix: 'ERROR:');
      rethrow;
    }
  }

  Future<void> registerUpload() async {
    try {
      final now = DateTime.now();
      final dateText = DateFormat('EEEE, dd-MM-yyyy', 'es').format(now);
      final timeText = DateFormat('hh:mm a').format(now);

      await _historyService.addHistoryEntry(
        dateText: dateText,
        timeText: timeText,
        status: 'upload',
      );

      AppLogger.log('Subida registrada', prefix: 'HISTORY:');
    } catch (e) {
      AppLogger.log('Error al registrar subida: $e', prefix: 'ERROR:');
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getHistoryStream() {
    return _historyService.getHistoryStream();
  }
}