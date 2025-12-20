import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/utils/readme.dart';

class WindowState {
  final double x;
  final double y;
  final double width;
  final double height;

  WindowState({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

class DraggableTerminalWindow extends StatefulWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;
  final String? readmePath;
  final double initialWidth;
  final double initialHeight;
  final double? initialX;
  final double? initialY;
  final Function(WindowState state)? onMinimize; // ✅ Pass window state

  const DraggableTerminalWindow({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
    this.readmePath,
    this.initialWidth = 800,
    this.initialHeight = 600,
    this.initialX,
    this.initialY,
    this.onMinimize,
  });

  @override
  State<DraggableTerminalWindow> createState() =>
      _DraggableTerminalWindowState();
}

class _DraggableTerminalWindowState extends State<DraggableTerminalWindow> {
  late double _width;
  late double _height;
  double _x = 0;
  double _y = 0;

  bool _isInitialized = false;

  static const double minWidth = 400;
  static const double minHeight = 300;
  static const double maxWidth = 1200;
  static const double maxHeight = 900;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
    _height = widget.initialHeight;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        setState(() {
          // Use saved position or center
          _x = widget.initialX ?? (size.width - _width) / 2;
          _y = widget.initialY ?? (size.height - _height) / 2;
          _isInitialized = true;
        });
      }
    });
  }

  void _minimizeWindow() {
    // Pass current state to parent and close dialog
    widget.onMinimize?.call(
      WindowState(x: _x, y: _y, width: _width, height: _height),
    );

    // Close the dialog
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SizedBox.shrink();
    }

    return Stack(
      children: [
        Positioned(
          left: _x,
          top: _y,
          child: GestureDetector(
            onPanUpdate: _handleDrag,
            child: Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTitleBar(),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Container(
                        color: Color(0xFF1E1E1E),
                        padding: EdgeInsets.all(16),
                        child: widget.child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildResizeHandles(),
      ],
    );
  }

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      _x += details.delta.dx;
      _y += details.delta.dy;

      final screenSize = MediaQuery.of(context).size;
      _x = _x.clamp(0.0, screenSize.width - _width);
      _y = _y.clamp(0.0, screenSize.height - 40);
    });
  }

  bool _isRedHovered = false;
  bool _isYellowHovered = false;
  bool _isGreenHovered = false;

  Widget _buildTitleBar() {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF2D2D2D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(width: 12),
                _buildTrafficLight(
                  Colors.red,
                  widget.onClose,
                  CupertinoIcons.xmark, // ✅ Cupertino X
                  _isRedHovered,
                  (hovered) => setState(() => _isRedHovered = hovered),
                ),
                SizedBox(width: 8),
                _buildTrafficLight(
                  Colors.yellow,
                  _minimizeWindow,
                  CupertinoIcons.minus, // ✅ Cupertino minus
                  _isYellowHovered,
                  (hovered) => setState(() => _isYellowHovered = hovered),
                ),
                SizedBox(width: 8),
                _buildTrafficLight(
                  Colors.green,
                  _maximizeWindow,
                  CupertinoIcons
                      .fullscreen, // ✅ Cupertino plus (or use CupertinoIcons.fullscreen)
                  _isGreenHovered,
                  (hovered) => setState(() => _isGreenHovered = hovered),
                ),
                SizedBox(width: 12),
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
                SizedBox(width: 80),
              ],
            ),
            if (widget.readmePath != null)
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => ReadmeDialog.show(context, widget.readmePath!),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficLight(
    Color color,
    VoidCallback? onTap,
    IconData icon,
    bool isHovered,
    Function(bool) onHoverChanged,
  ) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: isHovered
              ? Center(
                  child: Icon(
                    icon,
                    size: 8,

                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildResizeHandles() {
    return Stack(
      children: [
        // Bottom-right corner
        Positioned(
          left: _x + _width - 20,
          top: _y + _height - 20,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _width = (_width + details.delta.dx).clamp(minWidth, maxWidth);
                _height = (_height + details.delta.dy).clamp(
                  minHeight,
                  maxHeight,
                );
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeDownRight,
              child: Container(
                width: 20,
                height: 20,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white24,
                  size: 20,
                ),
              ),
            ),
          ),
        ),

        // Right edge
        Positioned(
          left: _x + _width - 5,
          top: _y + 40,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _width = (_width + details.delta.dx).clamp(minWidth, maxWidth);
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeRight,
              child: Container(
                width: 10,
                height: _height - 60,
                color: Colors.transparent,
              ),
            ),
          ),
        ),

        // Bottom edge
        Positioned(
          left: _x + 20,
          top: _y + _height - 5,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _height = (_height + details.delta.dy).clamp(
                  minHeight,
                  maxHeight,
                );
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeDown,
              child: Container(
                width: _width - 40,
                height: 10,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _maximizeWindow() {
    setState(() {
      final screenSize = MediaQuery.of(context).size;
      if (_width >= screenSize.width - 100 &&
          _height >= screenSize.height - 100) {
        _width = widget.initialWidth;
        _height = widget.initialHeight;
        _x = (screenSize.width - _width) / 2;
        _y = (screenSize.height - _height) / 2;
      } else {
        _width = screenSize.width - 100;
        _height = screenSize.height - 100;
        _x = 50;
        _y = 50;
      }
    });
  }
}
