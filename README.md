# Portfolio - DS

A Flutter Web portfolio with macOS-inspired design, showcasing professional animation architecture and technical documentation.

[Live Demo - Coming Soon](#) | [Documentation](#documentation) | [Changelog](CHANGELOG.md)

---

## 🎯 Overview

Developer portfolio featuring a macOS boot-style splash screen with smooth animations and interactive technical documentation. Built to demonstrate Flutter best practices, animation architecture, and resource management.

---

## 🛠️ Tech Stack

### Core
- **Flutter:** 3.38.5 (Latest stable)
- **Dart:** ^3.10.4
- **Platform:** Web (primary)

### Navigation
- **go_router:** ^17.0.1 - Declarative routing with deep linking support

### State Management
- **provider:** ^6.1.5+1 - Reactive state with ChangeNotifier pattern

### Data Persistence
- **hive_ce:** ^2.15.1 - NoSQL local database for command history
- **json_annotation:** ^4.9.0 - JSON serialization annotations
- **json_serializable:** ^6.11.3 - Type-safe JSON code generation
- **build_runner:** ^2.10.4 - Build-time code generation
- **path_provider:** ^2.1.5 - Platform-specific storage paths

### UI & Documentation
- **google_fonts:** ^6.3.3 - Courier Prime monospace typography
- **flutter_markdown_plus:** ^1.0.5 - README panel rendering
- **cached_network_image:** ^3.4.1 - Wallpaper loading with caching
- **url_launcher:** ^6.3.2 - External link launching

---

## 📁 Project Structure

```
lib/
├── main.dart
├── page_routes.dart
├── screens/
│   ├── splash_screen.dart
│   ├── macos_desktop.dart
│   └── mobile/
│       ├── mobile_terminal_screen.dart
│       └── terminal_state.dart
├── models/
│   ├── frontend_command_history.dart
│   └── frontend_command_history.g.dart
├── widgets/
│   └── terminal_window.dart
└── utils/
    ├── readme.dart
    └── responsive.dart
    └── minimised_apps_notifier.dart
assets/
└── markdown/
    ├── splash_screen.md
    ├── macos_desktop.md
    └── mobile_terminal.md
    └── draggable_terminal_window.md
```
---

## ✨ Features Implemented

### Splash Screen
- macOS-inspired boot loader
- Two-stage animation sequence (logo fade + progress bar)
- AnimationController with Intervals
- Hardware-accelerated rendering (FadeTransition)
- Efficient rebuilds (AnimatedBuilder)
- Proper resource management (dispose)

### README Panel System
- Floating action button (top-right, semi-transparent)
- Side panel with slide transition (right-to-left)
- Markdown rendering with custom styling
- VS Code dark theme colors
- Terminal aesthetic (cyan headers, green code blocks)

### macOS Desktop
- Interactive dock with distance-based magnification
- Real macOS behavior (smooth wave effect)
- Mouse position tracking via ChangeNotifier
- 6 dock icons: Mobile, Web, Backend, AWS, Call, Mail
- Responsive design (mobile/tablet/desktop breakpoints)
- Menu bar with blur effect (glass morphism)
- About dropdown menu (Resume, GitHub, LinkedIn)
- IST time display with location tooltip
- Dynamic wallpaper with caching

### Responsive System
- Custom breakpoint helper (no package bloat)
- Mobile (<600px), Tablet (600-1023px), Desktop (≥1024px)
- Adaptive sizing for dock icons, spacing, fonts
- Horizontal scroll fallback on mobile
- Touch-optimized interactions


### Mobile Terminal
- Interactive terminal interface with authentic CLI experience
- Build simulation for iOS/Android with stage-by-stage progress
- Provider state management with ChangeNotifier pattern
- Hive CE persistent storage for command history
- JSON serializable models for type-safe data persistence
- Dual-history system: session-based display + full persistent access
- Keyboard shortcuts: Up/Down arrow navigation
- Commands: build ios/android, clear, history, help
- Selectable terminal text for copy/paste
- Chat-style command history cards with timestamps
- Auto-scroll and auto-focus UX
---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.38.5 or higher
- Dart SDK 3.x or higher

### Installation
```bash
Clone repository
git clone https://github.com/yourusername/portfolio.git
cd portfolio
flutter pub get
flutter run -d chrome
flutter build web
```

### Configuration

**pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  go_router: ^17.0.1
  google_fonts: ^6.3.3
  flutter_markdown_plus: ^1.0.5
  cached_network_image: ^3.4.1
  url_launcher: ^6.3.2
  provider: ^6.1.5+1
  hive_ce: ^2.15.1
  json_annotation: ^4.9.0
  path_provider: ^2.1.5

dev_dependencies:
  json_serializable: ^6.11.3
  build_runner: ^2.10.4

flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
      - assets/markdown/

```

## 🎨 Design Principles

### Visual Style
- **Black background** - macOS boot aesthetic
- **White UI elements** - High contrast, clean
- **Monospace typography** - Developer/terminal theme
- **Minimal design** - Focus on content

### Animation Philosophy
- **60fps smooth** - Hardware acceleration where possible
- **Natural curves** - easeIn, easeInOut for organic feel
- **Purposeful motion** - Every animation serves UX
- **Performance-first** - Efficient rebuilds, single ticker

---

## 📚 Documentation

Each screen includes interactive technical documentation accessible via the info button (i) in the top-right corner.

**Current documentation:**
- `assets/markdown/splash_screen.md` - Animation architecture, widget decisions, performance optimizations
- `assets/markdown/macos_desktop.md` - Dock magnification system, responsive design, menu bar implementation
- `assets/markdown/mobile_terminal.md` - Terminal interface, state management, persistent storage, build simulation
- `assets/markdown/draggable_terminal_window.md` - Interactive draggable windows with minimize to dock

**Access:** Click floating action button on any screen to view implementation details.

---

## 🏗️ Architecture Decisions

### State Management

**Current implementations:**
- ChangeNotifier for dock mouse tracking
- Provider + ChangeNotifier for mobile terminal state
- Hive CE for persistent command history

**Pattern:** Reactive state with notifyListeners() → Consumer rebuilds

**Future:** BLoC, Riverpod implementations for comparison


### Data Persistence
**Hive CE** - Chosen for:
- NoSQL key-value storage (fast reads/writes)
- No code generation required (vs Hive classic)
- Web support (IndexedDB backend)
- Type-safe with JSON serialization
- Dual-history system (session + persistent)

### Navigation
**GoRouter** - Chosen for:
- Type-safe routing
- Deep linking support (web-critical)
- Declarative API (vs manual Navigator 2.0)
- Official Flutter recommendation

### Animation Strategy
- **Single AnimationController** - Multiple animations via Intervals
- **FadeTransition** - GPU-accelerated opacity
- **AnimatedBuilder** - Efficient subtree rebuilds
- **FractionallySizedBox** - Percentage-based responsive sizing

---

## 🎯 Performance

### Optimizations Implemented
1. **Single ticker** - One controller for logo + progress bar
2. **Hardware acceleration** - FadeTransition uses GPU rendering
3. **Efficient rebuilds** - AnimatedBuilder only rebuilds progress bar
4. **Memory management** - Proper dispose() prevents leaks
5. **Minimal dependencies** - Faster compilation, smaller bundle

### Metrics
- **First paint:** ~300ms
- **Animation:** Locked 60fps
- **Bundle size:** TBD (post-build)
- **Memory:** 16KB AnimationController (properly disposed)

---

## 📖 Learning Resources

This portfolio demonstrates:
- ✅ Flutter animation architecture
- ✅ Resource lifecycle management
- ✅ Hardware acceleration techniques
- ✅ Efficient widget rebuilds
- ✅ Custom transitions
- ✅ Markdown rendering
- ✅ Responsive design patterns
- ✅ Distance-based interactions
- ✅ RenderBox coordinate systems
- ✅ Web optimization
- ✅ Provider state management
- ✅ Hive CE local storage
- ✅ JSON serialization
- ✅ Command-line interface patterns
- ✅ Keyboard event handling



## 🔄 Current Status

**Completed:**
- ✅ Project setup (Flutter 3.38.5)
- ✅ GoRouter navigation structure
- ✅ Splash screen with animations
- ✅ README panel system
- ✅ macOS Desktop with interactive dock
- ✅ Menu bar with blur effect
- ✅ Responsive helper system
- ✅ Mobile Terminal with persistent history
- ✅ Provider state management
- ✅ Hive CE storage implementation
- ✅ Documentation (splash_screen.md, macos_desktop.md, mobile_terminal.md, draggable_terminal_window.md)
- ✅ Performance optimizations
- ✅ Interactive draggable windows with minimize to dock

**In Progress:**
- 🚧 Mobile project showcase (phone simulator UI)
- 🚧 Desktop windows system

**Planned:**
- 📋 Phone simulator with app icons
- 📋 BigShorts app details view
- 📋 Web projects section
- 📋 Backend projects section
- 📋 AWS projects section

---

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👤 Author

**DS** - Full-Stack Developer

- Portfolio: [Coming soon](#)
- GitHub: [@dhyaan-dds08](https://github.com/dhyaan-dds08)
- LinkedIn: [Dhyaan Shah](https://www.linkedin.com/in/dhyaan-shah-6220a31bb/)



## 🙏 Acknowledgments

### Framework & Tools
- **Flutter Team** - Excellent animation APIs and comprehensive documentation
- **Dart Team** - Robust language features and tooling
- **Material Design** - UI guidelines and design principles
- **VS Code** - Color palette inspiration (dark theme)

### Open Source Packages

Special thanks to the maintainers and contributors of these packages:

- **[go_router](https://pub.dev/packages/go_router)** by Flutter Team - Declarative routing made simple
- **[google_fonts](https://pub.dev/packages/google_fonts)** by Material Foundation - Easy access to 1000+ font families
- **[flutter_markdown_plus](https://pub.dev/packages/flutter_markdown_plus)** by community contributors - Markdown rendering for Flutter
- **[provider](https://pub.dev/packages/provider)** by Remi Rousselet - Simple and scalable state management
- **[hive_ce](https://pub.dev/packages/hive_ce)** by Community Edition maintainers - Fast and lightweight NoSQL database
- **[json_serializable](https://pub.dev/packages/json_serializable)** by Dart Team - Type-safe JSON serialization
- **[cached_network_image](https://pub.dev/packages/cached_network_image)** by Baseflow - Efficient image loading and caching
- **[url_launcher](https://pub.dev/packages/url_launcher)** by Flutter Team - URL launching capabilities


### Community
- Stack Overflow community for troubleshooting support
- Flutter Discord for real-time discussions
- GitHub open source contributors worldwide



**Built with Flutter 🐦 | Designed with care ✨ | Documented with purpose 📚**