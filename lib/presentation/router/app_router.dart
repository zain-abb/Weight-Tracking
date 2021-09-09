import 'package:flutter/material.dart';
import 'package:weight_tracker/presentation/screens/auth_screen.dart';
import 'package:weight_tracker/presentation/screens/home_screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  var routes = <String, WidgetBuilder>{
    AuthScreen.routeName: (ctx) => AuthScreen(),
    HomeScreen.routeName: (ctx) => HomeScreen(),
  };

  WidgetBuilder builder = routes[settings.name]!;
  return MaterialPageRoute(builder: (ctx) => builder(ctx));
}
