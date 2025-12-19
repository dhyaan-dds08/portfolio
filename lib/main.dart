import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:my_portfolio/page_routes.dart' show PageRoutes;
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // For mobile/desktop - use app documents directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }
  // For web - Hive uses browser storage automatically (no init needed)

  // Open box for frontend command history
  await Hive.openBox('frontendCommandHistory');

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
