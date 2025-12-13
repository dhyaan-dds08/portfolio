import 'package:flutter/material.dart';

class MacosDesktop extends StatefulWidget {
  const MacosDesktop({super.key});

  @override
  State<MacosDesktop> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MacosDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to the macOS Desktop!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
