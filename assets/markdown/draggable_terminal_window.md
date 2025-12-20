

## Window Management

### Draggable Terminal Window

**Interactive Window System**
```dart
class DraggableTerminalWindow extends StatefulWidget {
  final Function(WindowState state)? onMinimize;
  final double? initialX;
  final double? initialY;
  
  // Preserves position/size across minimize/restore
}
```

**Features:**
- **Drag-to-Move** - Click and drag title bar to reposition
- **Multi-Directional Resize** - Bottom-right corner, right edge, bottom edge
- **Screen Boundaries** - Auto-constrain to visible area
- **State Preservation** - Position and size persist during minimize

**Window Controls (Traffic Lights):**
- 🔴 **Red** - Close window and clear state
- 🟡 **Yellow** - Minimize to dock (preserves state)
- 🟢 **Green** - Maximize/restore window size

**Hover Interactions:**
- Traffic lights reveal icons on hover (Cupertino style)
- Red: `CupertinoIcons.xmark` (close)
- Yellow: `CupertinoIcons.minus` (minimize)
- Green: `CupertinoIcons.plus` (maximize)
- Smooth fade-in animations (150ms)

### Minimize to Dock

**macOS-Style Window Management**
```dart
void _minimizeWindow() {
  widget.onMinimize?.call(WindowState(
    x: _x, y: _y, width: _width, height: _height,
  ));
  Navigator.pop(context); // Close dialog completely
}
```

**Minimize Flow:**
```
User clicks yellow button
  ↓
Current state saved (position, size)
  ↓
Dialog closes (no background overhead)
  ↓
Icon appears in dock after divider
  ↓
Orange indicator dot shows minimized state
  ↓
Click dock icon to restore at exact position
```

**Why Close Dialog?**
- Zero memory overhead when minimized
- Clean state management
- Smooth restoration experience
- Supports multiple minimized windows

### Window State Management

**State Preservation**
```dart
class WindowState {
  final double x, y;
  final double width, height;
}

class MinimizedAppsNotifier extends ChangeNotifier {
  List<MinimizedApp> _minimizedApps = [];
  
  void addMinimizedApp(MinimizedApp app) {
    // Stores position, size, restore callback
  }
}
```

**Dock Integration:**
- Minimized apps appear after second divider
- Orange dot indicator on minimized icons
- Click to restore with preserved state
- Automatic removal on restore
- Supports multiple windows simultaneously

**Resize Constraints:**
- Minimum: 400x300 pixels
- Maximum: 1200x900 pixels
- Proportional resize (bottom-right corner)
- Edge-specific resize (right/bottom only)
- Visual cursors (resizeDownRight, resizeRight, resizeDown)

