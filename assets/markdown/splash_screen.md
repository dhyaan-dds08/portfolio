
# Splash Screen - Technical Documentation

macOS-inspired boot loader with animated logo and progress bar. Demonstrates Flutter animation architecture and resource management best practices.

---

## Tech Stack

**Flutter:** 3.38.5 | **Navigation:** GoRouter (declarative routing, deep linking) | **Route:** `/`

**Dependencies:**
- `google_fonts: ^6.1.0` - Courier Prime monospace font
- `flutter_markdown_plus: ^0.7.4` - README panel rendering

---

## Architecture

### StatefulWidget + SingleTickerProviderStateMixin

```dart
class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
```

**Why StatefulWidget?**
- `initState()` - initialize AnimationController
- `dispose()` - cleanup (prevents 16KB memory leak)
- Hold mutable animation references

**Why SingleTickerProviderStateMixin?**
- Provides `vsync` for screen-synced animations (60fps)
- Auto-pauses when app backgrounded (battery optimization)
- One ticker for multiple animations (efficient)

---

## Animation System

**One AnimationController, Two Animations**

```dart
AnimationController(vsync: this, duration: Duration(seconds: 3))
```

### Stage 1: Logo Fade (0.0s - 0.3s)

```dart
Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Interval(0.0, 0.1, curve: Curves.easeIn),
  ),
)
```

**Interval(0.0, 0.1)** - First 10% of timeline | **Curves.easeIn** - Slow start, accelerates

### Stage 2: Progress Bar (0.3s - 3.0s)

```dart
Interval(0.1, 1.0, curve: Curves.easeInOut)
```

**Remaining 90%** | **Curves.easeInOut** - Smooth start and end

### Stage 3: Continue Prompt (2.85s - 3.0s)
```dart
Interval(0.95, 1.0, curve: Curves.easeIn)
```

**Last 5% of timeline** | **Fades in after progress completes**

**Includes:** Pulsing indicator (infinite repeat animation) for visual attention

## Widget Rendering

**Logo:** `FadeTransition` - Hardware accelerated, GPU rendering, no setState()

**Progress:** `AnimatedBuilder` + `FractionallySizedBox`
- Rebuilds only progress subtree (efficient)
- Percentage-based width (0.0 = 0%, 1.0 = 100%)
- 60fps automatic updates

```dart
AnimatedBuilder(
  animation: _progressAnimation,
  builder: (context, child) {
    return FractionallySizedBox(
      widthFactor: _progressAnimation.value,
    );
  },
)
```

---

## Resource Management

```dart
@override
void dispose() {
  _controller.dispose(); // Stops ticker, frees memory
  super.dispose();
}
```

**Critical:** Without dispose, controller leaks 16KB per navigation + ticker runs indefinitely.

---

## README Panel

**Floating Action Button:** Top-right, 40x40dp (small), 10% opacity white

**Side Panel:** 500px width, right-to-left slide transition

```dart
Navigator.push(PageRouteBuilder(
  opaque: false, // Transparent overlay
  transitionsBuilder: (context, animation, _, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0), // Off-screen right
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
));
```

**Markdown Styling:** VS Code dark theme - `#1E1E1E` background, `#4EC9B0` cyan headers, `#00FF00` terminal green code

---

## Performance

1. **Single ticker** for both animations
2. **Hardware acceleration** - FadeTransition, GPU rendering
3. **Efficient rebuilds** - AnimatedBuilder (subtree only)
4. **Memory management** - Proper dispose()
5. **Minimal dependencies** - Smaller bundle, faster compilation

---

## Navigation Flow

### User-Controlled Navigation
```dart
bool _animationComplete = false;

_controller.addStatusListener((status) {
  if (status == AnimationStatus.completed) {
    setState(() => _animationComplete = true); // Mark complete, don't auto-navigate
  }
});

void _continue() {
  if (_animationComplete) {
    context.go('/desktop'); // User-triggered navigation
  }
}
```

**Animation completes → User chooses:**
- Click "Continue" prompt (fades in after animation)
- Click anywhere on screen
- View README via info button (ℹ️)

### Continue Prompt Animation
```dart
_continueOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Interval(0.95, 1.0, curve: Curves.easeIn),
  ),
);
```

**Stage 3: Continue Prompt (2.85s - 3.0s)**
- Fades in during last 5% of animation
- Includes pulsing indicator for attention
- "Click to continue" text with visual feedback

**Why User-Controlled?**
- Gives time to explore info button
- No arbitrary delays or forced countdowns
- Professional UX (user in control)
- Prevents rushed feeling

**Path:** Splash (3s animation) → User clicks → macOS Desktop

---

## Key Decisions

| Choice | Alternative | Why |
|--------|-------------|-----|
| StatefulWidget | StatelessWidget | Need initState/dispose for AnimationController |
| FadeTransition | AnimatedOpacity | Hardware accelerated, better performance |
| AnimatedBuilder | setState() | Rebuilds only subtree, no manual state |
| One controller | Two controllers | Synchronized, 16KB saved, cleaner code |
| PageRouteBuilder | showDialog() | Custom transitions, transparent overlay |
| GoRouter | Navigator 2.0 | Type-safe, deep linking, less boilerplate |
| User-controlled nav | Auto-navigation | Gives time to explore info, professional UX |

---

## File Structure

```
lib/screens/splash_screen.dart - Main screen
lib/utils/readme.dart - Side panel component
assets/markdown/splash_screen.md - This documentation
```

---

