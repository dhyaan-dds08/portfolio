import 'package:flutter/material.dart';

class MinimizedApp {
  final String id;
  final String title;
  final IconData icon;
  final VoidCallback onRestore;
  final double x;
  final double y;
  final double width;
  final double height;

  MinimizedApp({
    required this.id,
    required this.title,
    required this.icon,
    required this.onRestore,
    this.x = 0,
    this.y = 0,
    this.width = 800,
    this.height = 600,
  });
}

class MinimizedAppsNotifier extends ChangeNotifier {
  final List<MinimizedApp> _minimizedApps = [];

  List<MinimizedApp> get minimizedApps => _minimizedApps;

  void addMinimizedApp(MinimizedApp app) {
    if (!_minimizedApps.any((a) => a.id == app.id)) {
      _minimizedApps.add(app);
      notifyListeners();
    }
  }

  void removeMinimizedApp(String id) {
    _minimizedApps.removeWhere((app) => app.id == id);
    notifyListeners();
  }

  void restoreApp(String id) {
    final app = _minimizedApps.firstWhere((a) => a.id == id);
    app.onRestore();
    removeMinimizedApp(id);
  }
}
