import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/utils/readme.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _continueOpacityAnimation;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // Logo fade in (0.0s - 0.3s)
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.1, curve: Curves.easeIn),
      ),
    );

    // Progress bar fill (0.3s - 3.0s)
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Continue prompt fade in (after progress completes)
    _continueOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.95, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _animationComplete = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (_animationComplete) {
      context.push('/desktop'); // Navigate to macOS desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _continue, // Click anywhere to continue
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton.small(
            onPressed: () =>
                ReadmeDialog.show(context, 'assets/markdown/splash_screen.md'),
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Icon(Icons.info_outline, color: Colors.white, size: 20),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Stack(
          children: [
            // Main content (centered)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  FadeTransition(
                    opacity: _logoOpacityAnimation,
                    child: Text(
                      '<DS/>',
                      style: GoogleFonts.courierPrime(
                        fontSize: 64,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Progress Bar
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Continue prompt (bottom) - appears after animation
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _continueOpacityAnimation,
                child: Column(
                  children: [
                    // Click to continue text
                    Text(
                      'Click to continue',
                      style: GoogleFonts.courierPrime(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 2,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Pulsing indicator
                    _PulsingIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pulsing dot indicator
class _PulsingIndicator extends StatefulWidget {
  @override
  State<_PulsingIndicator> createState() => _PulsingIndicatorState();
}

class _PulsingIndicatorState extends State<_PulsingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _pulseAnimation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
    );
  }
}
