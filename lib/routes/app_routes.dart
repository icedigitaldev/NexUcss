import 'package:flutter/material.dart';
import 'package:nexucss/views/welcome_view.dart'; // Asegúrate de tener esta pantalla o crea el archivo con la pantalla WelcomeView

class AppRoutes {
  static const String welcomeScreen = '/welcome_view';

  static const String initialRoute = welcomeScreen;

  static Map<String, WidgetBuilder> routes = {
    welcomeScreen: (context) => const WelcomeView(),
  };
}
