import 'package:flutter/material.dart';
import 'package:nexucss/views/condition_view.dart';
import '../views/pincode_view.dart';
import '../views/welcome_view.dart';
import '../views/home_view.dart ';

class AppRoutes {

  static const String welcomeView = '/welcome';
  static const String pincodeView = '/pincode';
  static const String homeView = '/home';
  static const String conditionView = '/condition';

  static const String initialRoute = welcomeView;

  static Map<String, WidgetBuilder> routes = {
    welcomeView: (context) => const WelcomeView(),
    pincodeView: (context) => const PincodeView(),
    homeView: (context) => const HomeView(),
    conditionView: (context) => const ConditionView(),
  };
}
