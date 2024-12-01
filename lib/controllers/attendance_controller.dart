import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/attendance_service.dart';

final attendanceServiceProvider = Provider((ref) => AttendanceService());

final attendanceControllerProvider = Provider((ref) => AttendanceController(
  ref.watch(attendanceServiceProvider),
));

class AttendanceController {
  final AttendanceService _attendanceService;

  AttendanceController(this._attendanceService);

  Future<void> registrarAsistencia({
    required String idCurso,
    required String estado,
    required String ubicacion,
    required String numseccion,
    required String nombreProfesor,
    String? observacion,
    String? userId,
  }) async {
    await _attendanceService.registrarAsistencia(
      idCurso: idCurso,
      estado: estado,
      ubicacion: ubicacion,
      numseccion: numseccion,
      nombreProfesor: nombreProfesor,
      observacion: observacion,
      userId: userId,
    );
  }

  Future<Map<String, dynamic>?> obtenerAsistenciasPorFecha(String fecha) async {
    return await _attendanceService.obtenerAsistenciasPorFecha(fecha);
  }

  Future<Map<String, Map<String, dynamic>>> obtenerAsistenciasPorRango({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    return await _attendanceService.obtenerAsistenciasPorRango(
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }
}

// Provider para mantener las asistencias del rango seleccionado
final asistenciasRangoProvider = FutureProvider.family<Map<String, Map<String, dynamic>>, ({DateTime inicio, DateTime fin})>(
        (ref, fechas) async {
      final controller = ref.watch(attendanceControllerProvider);
      return await controller.obtenerAsistenciasPorRango(
        fechaInicio: fechas.inicio,
        fechaFin: fechas.fin,
      );
    }
);

// Provider para mantener las asistencias de una fecha específica
final asistenciasFechaProvider = FutureProvider.family<Map<String, dynamic>?, String>(
        (ref, fecha) async {
      final controller = ref.watch(attendanceControllerProvider);
      return await controller.obtenerAsistenciasPorFecha(fecha);
    }
);