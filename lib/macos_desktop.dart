import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_portfolio/utils/readme.dart';
import 'package:my_portfolio/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class MacOSDesktop extends StatefulWidget {
  const MacOSDesktop({super.key});

  @override
  State<MacOSDesktop> createState() => _MacOSDesktopState();
}

class _MacOSDesktopState extends State<MacOSDesktop> {
  double toolbarHeight = 20;

  String _getCurrentTime() {
    final ist = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
    final hour = ist.hour.toString().padLeft(2, '0');
    final minute = ist.minute.toString().padLeft(2, '0');
    return '$hour:$minute IST';
  }

  void _showAboutMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(16, 44, double.infinity, 0),
      color: Color(0xFF2C2C2C).withOpacity(0.95),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'about',
          height: 40,
          child: _MenuItemWidget(
            icon: Icons.info_outline,
            label: 'About <DS/>',
          ),
        ),
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          child: Divider(color: Colors.white.withOpacity(0.1), height: 1),
        ),
        PopupMenuItem<String>(
          value: 'resume',
          height: 40,
          child: _MenuItemWidget(
            icon: Icons.download_outlined,
            label: 'Download Resume',
          ),
        ),
        PopupMenuItem<String>(
          value: 'github',
          height: 40,
          child: _MenuItemWidget(icon: Icons.code, label: 'GitHub Profile'),
        ),
        PopupMenuItem<String>(
          value: 'linkedin',
          height: 40,
          child: _MenuItemWidget(
            icon: Icons.work_outline, // Work/professional icon
            label: 'LinkedIn Profile',
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'about') {
        print('Show About Dialog');
        // TODO: Next step
      } else if (value == 'resume') {
        print('Download Resume clicked');
      } else if (value == 'github') {
        final uri = Uri.parse('https://github.com/dhyaan-dds08');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else if (value == 'linkedin') {
        final uri = Uri.parse(
          'https://www.linkedin.com/in/dhyaan-shah-6220a31bb/',
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
        toolbarHeight: 44,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Row(
          children: [
            // Logo - clickable for About menu
            _MacOSMenuButton(
              label: '<DS/>',
              onPressed: () => _showAboutMenu(context),
            ),
          ],
        ),
        actions: [
          // Time
          Tooltip(
            message: 'Based in Mumbai, India (UTC + 5:30)',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  _getCurrentTime(),
                  style: GoogleFonts.courierPrime(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 50),
        child: FloatingActionButton.small(
          onPressed: () =>
              ReadmeDialog.show(context, 'assets/markdown/macos_desktop.md'),
          backgroundColor: Colors.white.withOpacity(0.1),
          child: Icon(Icons.info_outline, color: Colors.white, size: 20),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // macOS wallpaper background
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white.withOpacity(0.3),
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black,
                child: Center(
                  child: Icon(
                    Icons.wallpaper,
                    color: Colors.white.withOpacity(0.3),
                    size: 48,
                  ),
                ),
              ),
            ),
          ),

          // Dock at bottom
          Positioned(
            bottom: Responsive.isMobile(context) ? 10 : 20,
            left: 0,
            right: 0,
            child: Center(child: _MacOSDock()),
          ),
        ],
      ),
    );
  }
}

class _MenuItemWidget extends StatefulWidget {
  final IconData icon;
  final String label;

  const _MenuItemWidget({required this.icon, required this.label});

  @override
  State<_MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: Colors.white, size: 16),
            SizedBox(width: 12),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 3),
              child: Text(
                widget.label,
                style: GoogleFonts.courierPrime(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacOSMenuButton extends StatefulWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;

  const _MacOSMenuButton({this.icon, this.label, required this.onPressed});

  @override
  State<_MacOSMenuButton> createState() => _MacOSMenuButtonState();
}

class _MacOSMenuButtonState extends State<_MacOSMenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 4),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: widget.icon != null
              ? Icon(widget.icon, color: Colors.white, size: 16)
              : Text(
                  widget.label!,
                  style: GoogleFonts.courierPrime(
                    color: Colors.white,
                    fontSize: widget.label == '<DS/>'
                        ? 13
                        : 12, // Bigger for logo
                    fontWeight: widget.label == '<DS/>'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    letterSpacing: widget.label == '<DS/>' ? 2 : 0,
                  ),
                ),
        ),
      ),
    );
  }
}

class _MousePositionNotifier extends ChangeNotifier {
  Offset? _mousePosition;

  Offset? get mousePosition => _mousePosition;

  void updatePosition(Offset? position) {
    if (_mousePosition != position) {
      _mousePosition = position;
      notifyListeners();
    }
  }

  void clearPosition() {
    if (_mousePosition != null) {
      _mousePosition = null;
      notifyListeners();
    }
  }
}

class _MacOSDock extends StatefulWidget {
  @override
  State<_MacOSDock> createState() => _MacOSDockState();
}

class _MacOSDockState extends State<_MacOSDock> {
  late final _MousePositionNotifier _mouseNotifier;
  final List<GlobalKey> _iconKeys = List.generate(6, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _mouseNotifier = _MousePositionNotifier();
  }

  @override
  void dispose() {
    _mouseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      onHover: (event) {
        if (!isMobile) {
          _mouseNotifier.updatePosition(event.position);
        }
      },
      onExit: (_) {
        if (!isMobile) {
          _mouseNotifier.clearPosition();
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.dockPadding(context),
            vertical: Responsive.dockPadding(context),
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            // borderRadius: BorderRadius.circular(16),
            // border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildIcon(0, Icons.phone_iphone, 'Mobile', () {
                print(' clicked');
              }),
              SizedBox(width: Responsive.dockSpacing(context)),
              _buildIcon(1, Icons.language, 'Web', () {
                print(' clicked');
              }),
              SizedBox(width: Responsive.dockSpacing(context)),
              _buildIcon(2, Icons.terminal, 'Backend', () {
                print(' clicked');
              }),
              SizedBox(width: Responsive.dockSpacing(context)),
              _buildIcon(3, Icons.cloud, 'AWS', () {
                print(' clicked');
              }),

              // Divider
              Container(
                width: 1,
                height: Responsive.dockDividerHeight(context),
                margin: EdgeInsets.symmetric(
                  horizontal: Responsive.dockSpacing(context),
                ),
                color: Colors.white.withOpacity(0.2),
              ),

              _buildIcon(4, Icons.phone, 'Call', () {
                print(' clicked');
              }),
              SizedBox(width: Responsive.dockSpacing(context)),
              _buildIcon(5, Icons.email, 'Mail', () {
                print(' clicked');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(
    int index,
    IconData icon,
    String label,
    Function() onpressed,
  ) {
    return _DockIcon(
      key: _iconKeys[index],
      icon: icon,
      label: label,
      mouseNotifier: _mouseNotifier,
      onTap: onpressed,
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final _MousePositionNotifier mouseNotifier;
  final VoidCallback onTap;

  const _DockIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.mouseNotifier,
    required this.onTap,
  });

  double _calculateScale(BuildContext context, Offset? mousePosition) {
    if (mousePosition == null) return 1.0;

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return 1.0;

    // Get icon position
    final iconPosition = box.localToGlobal(Offset.zero);
    final iconCenter =
        iconPosition + Offset(box.size.width / 2, box.size.height / 2);

    // Calculate distance from mouse to icon center
    final distance = (mousePosition - iconCenter).distance;

    // Magnification range: 150px radius
    const maxDistance = 150.0;
    if (distance > maxDistance) return 1.0;

    // Scale from 1.0 to 1.33 based on distance
    final scale = 1.0 + (1.0 - (distance / maxDistance)) * 0.33;
    return scale.clamp(1.0, 1.33);
  }

  @override
  Widget build(BuildContext context) {
    final baseSize = Responsive.dockIconSize(context);
    final isMobile = Responsive.isMobile(context);

    return GestureDetector(
      onTap: onTap,
      child: ListenableBuilder(
        listenable: mouseNotifier,
        builder: (context, child) {
          final mousePosition = mouseNotifier.mousePosition;
          final scale = isMobile
              ? 1.0
              : _calculateScale(context, mousePosition);
          final currentSize = baseSize * scale;
          final isHovered = scale > 1.05;

          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: baseSize, end: currentSize),
            builder: (context, animatedSize, child) {
              return SizedBox(
                width: baseSize * 1.33, // Reserve space for max size
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Label (desktop only, on hover)
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 150),
                      opacity: (isHovered && !isMobile) ? 1.0 : 0.0,
                      child: Container(
                        height: 18,
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: GoogleFonts.courierPrime(
                              fontSize: Responsive.fontSizeSmall(context),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (isHovered && !isMobile) SizedBox(height: 4),

                    // Icon container
                    Container(
                      width: animatedSize,
                      height: animatedSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          Responsive.dockBorderRadius(context),
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(
                            isHovered ? 0.3 : 0.1,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: animatedSize * 0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
