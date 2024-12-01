import '../services/pin_service.dart';
import '../utils/logger.dart';

class PincodeController {
  final PinService _pinService = PinService();

  String enteredPin = '';
  bool isLoading = false;
  int maxAttempts = 3;

  PincodeController() {
    //_initializeUsers();
  }

  Future<void> _initializeUsers() async {
    try {
      AppLogger.log('Iniciando creación de usuarios...', prefix: 'INIT:');
      await _pinService.createInitialUsers();
      AppLogger.log('Usuarios creados exitosamente', prefix: 'INIT:');
    } catch (e) {
      AppLogger.log('Error al crear usuarios iniciales: $e', prefix: 'INIT:');
    }
  }

  Future<Map<String, dynamic>> validatePin() async {
    try {
      final result = await _pinService.validatePin(enteredPin);

      if (!result['isValid']) {
        await _pinService.registerFailedAttempt(enteredPin);
      }

      return result;
    } catch (e) {
      AppLogger.log('Error en controlador PIN: $e', prefix: 'PIN_CONTROLLER:');
      return {'isValid': false, 'message': 'Error al validar PIN'};
    }
  }

  void onNumberTapped(String number, Function setState) {
    if (enteredPin.length < 4) {
      setState(() {
        enteredPin += number;
      });
    }
  }

  void onCancelText(Function setState) {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  void clearPin(Function setState) {
    setState(() {
      enteredPin = '';
    });
  }

  void setLoading(bool value, Function setState) {
    setState(() {
      isLoading = value;
    });
  }
}