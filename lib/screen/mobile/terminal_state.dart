import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:my_portfolio/models/frontend_command_history.dart';

enum BuildState { idle, building, complete, simulatorReady }

class TerminalState extends ChangeNotifier {
  // State variables
  BuildState _buildState = BuildState.idle;
  String _selectedPlatform = '';
  double _buildProgress = 0.0;
  List<String> _buildLogs = [];
  int _historyIndex = -1;

  late Box _historyBox;

  // Session-specific history (only current session, visible in UI)
  List<FrontendCommandHistory> _sessionHistory = [];

  // Getters
  BuildState get buildState => _buildState;
  String get selectedPlatform => _selectedPlatform;
  double get buildProgress => _buildProgress;
  List<String> get buildLogs => _buildLogs;
  int get historyIndex => _historyIndex;
  Box get historyBox => _historyBox;

  // Get only current session history (for display)
  List<FrontendCommandHistory> getSessionHistory() {
    return _sessionHistory;
  }

  // Initialize Hive box
  void initializeHive() {
    _historyBox = Hive.box('frontendCommandHistory');
    _sessionHistory = []; // Start with empty session
    notifyListeners();
  }

  // Get ALL command history (for up/down arrow navigation)
  List<FrontendCommandHistory> getAllCommandHistory() {
    final historyItems = <FrontendCommandHistory>[];
    for (var key in _historyBox.keys) {
      try {
        final json = Map<String, dynamic>.from(_historyBox.get(key));
        historyItems.add(FrontendCommandHistory.fromJson(json));
      } catch (e) {
        print('Error parsing history: $e');
      }
    }
    historyItems.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return historyItems;
  }

  // Save command to history
  Future<void> saveCommand(String command, String output, bool success) async {
    final history = FrontendCommandHistory(
      command: command,
      timestamp: DateTime.now(),
      output: output,
      success: success,
    );

    // Save to persistent storage
    await _historyBox.put(
      DateTime.now().millisecondsSinceEpoch.toString(),
      history.toJson(),
    );

    // Add to current session
    _sessionHistory.add(history);

    notifyListeners();
  }

  // Clear history
  Future<void> clearHistory() async {
    await _historyBox.clear();
    _sessionHistory.clear();
    _buildState = BuildState.idle;
    _buildLogs.clear();
    notifyListeners();
  }

  // Start build
  void startBuild(String platform) {
    _selectedPlatform = platform;
    _buildState = BuildState.building;
    _buildProgress = 0.0;
    _buildLogs = [];
    notifyListeners();
  }

  // Update build progress
  void updateProgress(double progress) {
    _buildProgress = progress;
    notifyListeners();
  }

  // Add build log
  void addLog(String log) {
    _buildLogs.add(log);
    notifyListeners();
  }

  // Replace last log (for checkmark updates)
  void replaceLastLog(String oldText, String newText) {
    if (_buildLogs.isNotEmpty) {
      _buildLogs[_buildLogs.length - 1] = _buildLogs[_buildLogs.length - 1]
          .replaceAll(oldText, newText);
      notifyListeners();
    }
  }

  // Complete build
  void completeBuild() {
    _buildState = BuildState.complete;
    notifyListeners();
  }

  // Launch simulator
  void launchSimulator() {
    _buildState = BuildState.simulatorReady;
    notifyListeners();
  }

  // Navigate history (up arrow) - uses ALL history
  String? navigateHistoryUp(List<FrontendCommandHistory> allHistory) {
    if (allHistory.isNotEmpty && _historyIndex < allHistory.length - 1) {
      _historyIndex++;
      return allHistory[allHistory.length - 1 - _historyIndex].command;
    }
    return null;
  }

  // Navigate history (down arrow) - uses ALL history
  String? navigateHistoryDown(List<FrontendCommandHistory> allHistory) {
    if (_historyIndex > 0) {
      _historyIndex--;
      return allHistory[allHistory.length - 1 - _historyIndex].command;
    } else if (_historyIndex == 0) {
      _historyIndex = -1;
      return '';
    }
    return null;
  }

  // Reset history index
  void resetHistoryIndex() {
    _historyIndex = -1;
  }
}
