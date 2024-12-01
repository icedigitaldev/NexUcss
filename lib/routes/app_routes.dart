import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/condition_view.dart';
import '../views/pincode_view.dart';
import '../views/welcome_view.dart';
import '../views/home_view.dart';
import '../utils/logger.dart';

class AppRoutes {
  static const String welcomeView = '/welcome';
  static const String pincodeView = '/pincode';
  static const String homeView = '/home';
  static const String conditionView = '/condition';

  static Future<String> getInitialRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final termsAccepted = prefs.getBool('terms_accepted') ?? false;

      if (termsAccepted) {
        AppLogger.log('Términos aceptados, iniciando en PIN', prefix: 'ROUTES:');
        return pincodeView;
      }

      AppLogger.log('Términos no aceptados, iniciando en Welcome', prefix: 'ROUTES:');
      return welcomeView;
    } catch (e) {
      AppLogger.log('Error al verificar ruta inicial: $e', prefix: 'ERROR:');
      return welcomeView;
    }
  }

  static Map<String, WidgetBuilder> routes = {
    welcomeView: (context) => const WelcomeView(),
    pincodeView: (context) => const PincodeView(),
    homeView: (context) => const HomeView(),
    conditionView: (context) => const ConditionView(),
  };
}