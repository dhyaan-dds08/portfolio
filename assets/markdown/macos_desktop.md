# macOS Desktop - Technical Documentation

Full-featured macOS desktop interface with interactive dock, distance-based magnification, and responsive design. Demonstrates advanced Flutter animations and efficient state management.


**This screen demonstrates:**
- Advanced animation techniques (distance-based scaling, smooth interpolation)
- Efficient state management (ChangeNotifier, targeted rebuilds)
- Render box coordinate system mastery
- Real macOS dock behavior replication
- Production-ready performance optimizations
- Clean architecture patterns

## Tech Stack

**Flutter:** 3.38.5 | **Navigation:** GoRouter | **Route:** `/desktop`

**Dependencies:**
- `cached_network_image: ^3.4.1` - Wallpaper loading with caching
- `google_fonts: ^6.3.3` - Courier Prime typography
- Custom responsive helper (no package bloat)
- `url_launcher: ^6.3.2` - A Flutter plugin for launching a URL 

## Architecture

### State Management Strategy

**Mouse Position Tracking:**
- `_MousePositionNotifier` (ChangeNotifier) - Single source of truth for mouse position
- `ListenableBuilder` - Efficient rebuilds (only icons update, not entire dock)
- No `setState()` - Clean separation of state and UI

**Why ChangeNotifier?**
- Centralized mouse tracking (one listener vs 6 individual hover states)
- Smooth magnification across multiple icons simultaneously
- Testable state logic
- Scalable for future features (window management, badges, etc.)

### Component Hierarchy
```
MacOSDesktop (StatefulWidget)
├─ Background (CachedNetworkImage)
└─ _MacOSDock (StatefulWidget)
   ├─ _MousePositionNotifier (ChangeNotifier)
   ├─ MouseRegion (tracks global position)
   └─ Row of _DockIcon (StatelessWidget)
      └─ ListenableBuilder (rebuilds on mouse move)
```


## macOS Menu Bar System

### AppBar Implementation

**Blur Effect AppBar:**
- `toolbarHeight: 44` - Standard macOS menu bar height
- `BackdropFilter` with `ImageFilter.blur(sigmaX: 10, sigmaY: 10)` - Glass morphism effect
- `backgroundColor: Colors.black.withOpacity(0.4)` - Semi-transparent dark background

### Interactive Menu Components

**`_MacOSMenuButton`:**
- Stateful widget with hover detection
- Highlights on hover with `Colors.white.withOpacity(0.2)`
- Supports both icon and text labels
- Custom styling for logo (`<DS/>`) - larger font, bold, letter spacing

**`_MenuItemWidget`:**
- Stateful widget for individual menu items
- Hover effect with subtle background change
- Icon + label layout with proper spacing
- Consistent Courier Prime typography

### About Menu

**Dropdown Menu (`_showAboutMenu`):**
- Positioned at `RelativeRect.fromLTRB(16, 44, double.infinity, 0)` - Below AppBar, left-aligned
- Dark theme: `Color(0xFF2C2C2C).withOpacity(0.95)`
- Rounded corners: `BorderRadius.circular(12)`
- Elevation: 8 for depth

**Menu Items:**
1. **About <DS/>** - Shows portfolio information (TODO: Dialog)
2. **Download Resume** - Triggers resume download (TODO: Implementation)
3. **GitHub Profile** - Opens GitHub in new tab via `url_launcher`
4. **LinkedIn Profile** - Opens LinkedIn in new tab via `url_launcher`

### IST Time Display

**Time Function (`_getCurrentTime`):**
```dart
String _getCurrentTime() {
  final ist = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
  final hour = ist.hour.toString().padLeft(2, '0');
  final minute = ist.minute.toString().padLeft(2, '0');
  return '$hour:$minute IST';
}
```

**Features:**
- Displays developer's local time (IST) - not user's time
- Tooltip on hover: "Based in Mumbai, India (UTC + 5:30)"
- Shows availability context to recruiters
- Updates on rebuild

### External Links

**Package:** `url_launcher: ^6.2.5`

**Implementation:**
```dart
final uri = Uri.parse('https://github.com/dhyaan-dds08');
if (await canLaunchUrl(uri)) {
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
```

**Links:**
- GitHub: `https://github.com/dhyaan-dds08`
- LinkedIn: `https://www.linkedin.com/in/dhyaan-shah-6220a31bb/`

### Menu Interaction Flow
```
User clicks <DS/> logo
    ↓
showMenu() displays dropdown
    ↓
User hovers over menu item (highlights)
    ↓
User clicks menu item
    ↓
Action triggers:
  - About: Show dialog (TODO)
  - Resume: Download PDF (TODO)
  - GitHub: Open in new tab ✓
  - LinkedIn: Open in new tab ✓
```

### Design Decisions

| Element | Choice | Rationale |
|---------|--------|-----------|
| Time display | IST (developer's timezone) | Portfolio is about the developer, shows availability |
| Menu position | Left-aligned below AppBar | Follows macOS convention (Apple menu top-left) |
| Blur effect | Gaussian blur (10px) | Modern glass morphism, matches macOS Big Sur+ aesthetic |
| Menu styling | Dark with rounded corners | Consistent with macOS dark mode |
| External links | `url_launcher` package | Cross-platform, handles different environments |
| Hover effects | Subtle opacity changes | Provides feedback without being distracting |

### Responsive Behavior

**Mobile:**
- Menu still functional (tap-based)
- Time display remains visible
- Hover effects disabled (no mouse)
- Menu items spaced for touch targets

**Desktop:**
- Full hover interactions
- Smooth highlight transitions
- Precise positioning
- Tooltip on time display

## Dock Magnification System

### Distance-Based Scaling (Real macOS Behavior)

Unlike simple hover (on/off), icons scale based on **distance from mouse cursor**.
**Problem:** Mouse position is global (entire screen), icon position starts as local (within its own box).

**Solution:** Convert icon position to global coordinates for comparison.

```dart
// Local: Icon's perspective (always starts at 0,0)
Offset(0, 0) in icon's box

// Global: Screen's perspective
final iconPosition = box.localToGlobal(Offset.zero);
// e.g., Offset(500, 830) on screen

// Icon center (global)
final iconCenter = iconPosition + Offset(width/2, height/2);
// e.g., Offset(530, 860) for 60x60 icon
```

## Animation Strategy

### TweenAnimationBuilder (Smooth Scaling)
```dart
TweenAnimationBuilder(
  duration: Duration(milliseconds: 200),
  curve: Curves.easeOutCubic,
  tween: Tween(begin: baseSize, end: currentSize),
  builder: (context, animatedSize, child) {
    // Icon grows/shrinks smoothly
  },
)
```

**Why TweenAnimationBuilder over AnimatedContainer:**
- More control over animation curves
- Better performance (rebuilds only animated values)
- Smoother transitions when target changes rapidly


## Responsive Design

### Breakpoints (via Responsive Helper)
```dart
// Mobile: < 600px
baseSize: 50px
hoveredSize: 60px
spacing: 4px
padding: 8px
No magnification (cannot hover on touch)

// Desktop: ≥ 1024px
baseSize: 60px
hoveredSize: 80px (via magnification formula)
spacing: 8px
padding: 12px
Full magnification effect
```

### Mobile Optimizations

- **No MouseRegion effects** - `if (!isMobile)` guards prevent unnecessary calculations
- **Smaller icons** - Touch targets still meet 44dp minimum
- **Horizontal scroll** - `SingleChildScrollView` if icons overflow
- **No labels** - Saves vertical space
- **Bottom margin reduced** - 10px vs 20px on desktop


## Key Decisions

| Choice | Alternative | Why |
|--------|-------------|-----|
| ChangeNotifier | setState() | Centralized state, testable, efficient rebuilds |
| Distance-based scale | Simple hover | Real macOS behavior, smooth wave effect |
| TweenAnimationBuilder | AnimatedContainer | Better curve control, smoother rapid changes |
| RenderBox calculations | Fixed positions | Dynamic, works at any screen size/position |
| SingleChildScrollView | Fixed width dock | Mobile-friendly, handles overflow gracefully |
| CachedNetworkImage | NetworkImage | Caching, loading states, error handling |

## File Structure
```
lib/screens/macos_desktop.dart - This screen
lib/utils/responsive.dart - Breakpoint helper
assets/markdown/macos_desktop.md - This documentation
```
