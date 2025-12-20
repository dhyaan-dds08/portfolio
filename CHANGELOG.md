# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Version selector screen
- macOS desktop UI (dock, windows, menu bar)
- BLoC implementation
- Riverpod implementation
- GetX implementation
- Project showcase sections (iOS, Android, Web, Backend)
- Side-by-side comparison mode


## [0.1.4] - 2025-12-20
- Terminal window now fully draggable and resizable
- Window controls now interactive with hover states
- Dock dynamically shows minimized applications
- Terminal state persists across minimize/restore cycles

Dependencies: Provider, Hive CE, JSON Serializable, Path Provider

## [0.1.3] - 2025-12-19
- added native splash screen so that until the flutter stuff is initialised we still see the same splash screen and not default html splash
- Interactive terminal with build simulation
- Provider state management (ChangeNotifier)
- Hive CE persistent storage
- JSON serializable command history
- Keyboard shortcuts and history navigation
- Dual-history system (session + persistent)
- iOS/Android build workflows
- Selectable text and professional UI

Dependencies: Provider, Hive CE, JSON Serializable, Path Provider



## [0.1.2] - 2025-12-14

### Added
- macOS Desktop screen with interactive dock
- Distance-based icon magnification (real macOS behavior)
- Menu bar with About dropdown (Resume, GitHub, LinkedIn links)
- IST time display with location tooltip
- Responsive helper for breakpoints
- Wallpaper with CachedNetworkImage

### Changed
- Dock uses ChangeNotifier for mouse tracking
- Time shows IST (developer timezone)

### Dependencies
- `cached_network_image: ^3.4.1`
- `url_launcher: ^6.2.5`

## [0.1.1] - 2025-12-13

### Changed
- Removed auto-navigation from splash screen
- User must click to continue after animation

### Added
- Continue prompt with fade-in animation
- Pulsing dot indicator
- Click-anywhere navigation
- Desktop route with fade transition
- .gitignore file

### Fixed
- Git tracking of build artifacts
- Asset path in README panel

## [0.1.0] - 2025-12-13

### Added
- **Project initialization**
  - Flutter 3.38.5 setup
  - Web platform configuration
  - Basic project structure

- **Navigation system**
  - GoRouter integration (go_router: ^17.0.1)
  - Declarative routing with deep linking
  - PageRoutes configuration
  - Initial route: `/` (splash screen)

- **Splash screen** (`lib/screens/splash_screen.dart`)
  - macOS-inspired boot loader
  - Two-stage animation sequence:
    - Logo fade-in (0.0s - 0.3s, Curves.easeIn)
    - Progress bar fill (0.3s - 3.0s, Curves.easeInOut)
  - AnimationController with Intervals
  - FadeTransition for logo (hardware accelerated)
  - AnimatedBuilder for progress bar (efficient rebuilds)
  - FractionallySizedBox for responsive width
  - Proper resource cleanup (dispose)

- **README panel system** (`lib/utils/readme.dart`)
  - Floating action button (top-right, 40x40dp)
  - Side panel component (500px width)
  - Slide transition (right-to-left, PageRouteBuilder)
  - Markdown rendering (flutter_markdown_plus: ^0.7.4)
  - Custom styling (VS Code dark theme)
  - Click-to-close backdrop

- **Documentation**
  - Technical README for splash screen (`assets/markdown/splash_screen.md`)
  - Main project README.md
  - CHANGELOG.md (this file)

- **Dependencies**
  - `google_fonts: ^6.3.3 (Courier Prime typography)`
  - `flutter_markdown_plus: ^1.0.5 (documentation rendering)`
  - `go_router: ^17.0.1 (navigation)`

### Technical Details
- **Animation architecture**
  - Single AnimationController with SingleTickerProviderStateMixin
  - Interval-based sequencing (no multiple controllers)
  - 60fps locked performance
  - Memory-efficient (16KB controller, properly disposed)

- **Performance optimizations**
  - Hardware-accelerated widgets (FadeTransition)
  - Efficient rebuilds (AnimatedBuilder subtree only)
  - Minimal dependencies strategy
  - Const constructors where possible

- **Code quality**
  - Type-safe navigation
  - Proper lifecycle management (initState/dispose)
  - Clean separation of concerns
  - Comprehensive inline documentation

### File Structure
```
lib/
├── main.dart
├── routes/page_routes.dart
├── screens/splash_screen.dart
└── utils/readme.dart

assets/
└── markdown/splash_screen.md
```

---

## Development Notes

### Version Naming
- **Major.Minor.Patch** (Semantic Versioning)
- **0.x.x** - Pre-release development
- **1.0.0** - First production release (when all features complete)

[0.1.2]: https://github.com/dhyaan-dds08/portfolio/releases/tag/v0.1.2
[0.1.1]: https://github.com/dhyaan-dds08/portfolio/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/dhyaan-dds08/portfolio/releases/tag/v0.1.0