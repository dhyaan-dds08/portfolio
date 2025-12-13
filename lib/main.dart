import 'package:flutter/material.dart';
import 'package:my_portfolio/page_routes.dart' show PageRoutes;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: PageRoutes.goRouter,
    );
  }
}
