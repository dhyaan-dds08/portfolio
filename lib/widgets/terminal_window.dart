import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/utils/readme.dart';

class TerminalWindow extends StatefulWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;

  const TerminalWindow({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  @override
  State<TerminalWindow> createState() => _TerminalWindowState();
}

class _TerminalWindowState extends State<TerminalWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 600,
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E), // VS Code dark theme
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        backgroundColor: Color(0xFF1E1E1E),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 50, right: 0),
          child: FloatingActionButton.small(
            onPressed: () => ReadmeDialog.show(
              context,
              'assets/markdown/mobile_Terminal.md',
            ),
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Icon(Icons.info_outline, color: Colors.white, size: 20),
          ),
        ),
        body: Column(
          children: [
            // Title bar
            _buildTitleBar(),

            // Terminal content
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 12),

          // Traffic lights (macOS style)
          _buildTrafficLight(Colors.red, widget.onClose),
          SizedBox(width: 8),
          _buildTrafficLight(Colors.yellow, null),
          SizedBox(width: 8),
          _buildTrafficLight(Colors.green, null),

          SizedBox(width: 12),

          // Title
          Expanded(
            child: Center(
              child: Text(
                widget.title,
                style: GoogleFonts.courierPrime(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          SizedBox(width: 80), // Balance for traffic lights
        ],
      ),
    );
  }

  Widget _buildTrafficLight(Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.5), width: 0.5),
        ),
      ),
    );
  }
}
