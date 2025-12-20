import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/models/frontend_command_history.dart';
import 'package:my_portfolio/screen/mobile/terminal_state.dart';
import 'package:my_portfolio/utils/readme.dart';

import 'package:my_portfolio/widgets/terminal_window.dart';
import 'package:provider/provider.dart';

class MobileTerminalScreen extends StatefulWidget {
  const MobileTerminalScreen({super.key});

  @override
  State<MobileTerminalScreen> createState() => _MobileTerminalScreenState();
}

class _MobileTerminalScreenState extends State<MobileTerminalScreen> {
  // UI Controllers only (not state)
  final TextEditingController _commandController = TextEditingController();
  final FocusNode _commandFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TerminalState>().initializeHive();
      _commandFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _commandController.dispose();
    _commandFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _commandFocusNode.requestFocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Consumer<TerminalState>(
          builder: (context, state, child) {
            switch (state.buildState) {
              case BuildState.idle:
                return _buildIdleState(state);
              case BuildState.building:
                return _buildBuildingState(state);
              case BuildState.complete:
                return _buildCompleteState(state);
              case BuildState.simulatorReady:
                return _buildSimulatorState(state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildIdleState(TerminalState state) {
    final historyItems = state
        .getSessionHistory(); // ✅ Changed: Only session history

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            children: [
              _buildTerminalPrompt('cd mobile-projects'),
              SizedBox(height: 8),
              _buildTerminalPrompt('~/mobile-projects'),
              SizedBox(height: 24),

              _buildComment('# Mobile App Projects'),
              _buildComment('# Choose a platform to build and deploy'),
              _buildComment('# Type a command or click to execute'),
              SizedBox(height: 24),

              _buildTerminalText(
                'Available build targets:',
                color: Colors.cyan,
              ),
              SizedBox(height: 16),

              // iOS Build Option
              _buildBuildOption(
                platform: 'ios',
                command: 'flutter build ios --release',
                icon: '🍎',
                title: 'Build for iOS',
                details: [
                  'Platform: iPhone & iPad',
                  'Output: Runner.app',
                  'Target SDK: iOS 17.0+',
                ],
              ),

              SizedBox(height: 16),

              // Android Build Option
              _buildBuildOption(
                platform: 'android',
                command: 'flutter build apk --release',
                icon: '🤖',
                title: 'Build for Android',
                details: [
                  'Platform: Android Devices',
                  'Output: app-release.apk',
                  'Target SDK: Android 13+',
                ],
              ),

              SizedBox(height: 32),

              // Command history (only current session)
              ...historyItems.map((history) {
                return _buildCommandHistoryItem(history);
              }),
            ],
          ),
        ),
        _buildCommandInput(state),
      ],
    );
  }

  Widget _buildCommandHistoryItem(FrontendCommandHistory history) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF252526),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: history.success
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                history.success ? Icons.check_circle : Icons.error,
                color: history.success ? Colors.green : Colors.red,
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildTerminalText(
                  '\$ ${history.command}',
                  color: Color(0xFF4EC9B0),
                ),
              ),
              Text(
                _formatTimestamp(history.timestamp),
                style: GoogleFonts.courierPrime(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          if (history.output != null) ...[
            SizedBox(height: 8),
            _buildTerminalText(
              history.output!,
              color: history.success ? Colors.white70 : Colors.red.shade300,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _buildBuildOption({
    required String platform,
    required String command,
    required String icon,
    required String title,
    required List<String> details,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _startBuild(platform),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTerminalText('\$ $command', color: Color(0xFF4EC9B0)),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(icon, style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.courierPrime(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ...details.map(
                (detail) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: _buildTerminalText(detail, color: Colors.white70),
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Execute Command',
                      style: GoogleFonts.courierPrime(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.green, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COMMAND INPUT
  // ============================================================
  Widget _buildCommandInput(TerminalState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF252526),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) => _handleKeyPress(event, state),
        child: Row(
          children: [
            _buildTerminalText('dhyaan@portfolio ', color: Colors.green),
            _buildTerminalText('~/mobile-projects', color: Colors.blue),
            _buildTerminalText(' % ', color: Colors.white),
            Expanded(
              child: TextField(
                controller: _commandController,
                focusNode: _commandFocusNode,
                style: GoogleFonts.courierPrime(
                  color: Colors.white,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Type command...',
                  hintStyle: GoogleFonts.courierPrime(
                    color: Colors.white30,
                    fontSize: 13,
                  ),
                ),
                onSubmitted: (cmd) => _executeCommand(cmd, state),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.green, size: 18),
              onPressed: () => _executeCommand(_commandController.text, state),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleKeyPress(RawKeyEvent event, TerminalState state) {
    if (event is! RawKeyDownEvent) return;

    final allHistory = state
        .getAllCommandHistory(); // ✅ Changed: Get ALL history for navigation

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final command = state.navigateHistoryUp(allHistory);
      if (command != null) {
        setState(() {
          _commandController.text = command;
          _commandController.selection = TextSelection.fromPosition(
            TextPosition(offset: command.length),
          );
        });
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final command = state.navigateHistoryDown(allHistory);
      if (command != null) {
        setState(() {
          _commandController.text = command;
          _commandController.selection = TextSelection.fromPosition(
            TextPosition(offset: command.length),
          );
        });
      }
    }
  }

  void _executeCommand(String command, TerminalState state) async {
    command = command.trim();
    if (command.isEmpty) return;

    final commandLower = command.toLowerCase();

    if (commandLower.contains('flutter build ios') ||
        commandLower.contains('flutter build iphoneos')) {
      await state.saveCommand(command, 'Building iOS app...', true);
      _startBuild('ios');
    } else if (commandLower.contains('flutter build apk') ||
        commandLower.contains('flutter build android')) {
      await state.saveCommand(command, 'Building Android app...', true);
      _startBuild('android');
    } else if (commandLower == 'clear' || commandLower == 'cls') {
      await state.saveCommand(command, 'Terminal cleared', true);
      await state.clearHistory();
    } else if (commandLower == 'history') {
      // Get ALL history from Hive
      final allHistory = state.getAllCommandHistory();

      if (allHistory.isEmpty) {
        await state.saveCommand(command, 'No command history found.', true);
      } else {
        // Format history list
        final historyOutput = allHistory
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key + 1;
              final hist = entry.value;
              final timeAgo = _formatTimestamp(hist.timestamp);
              return '$index. ${hist.command} ($timeAgo)';
            })
            .join('\n');

        await state.saveCommand(
          command,
          'Command History:\n$historyOutput',
          true,
        );
      }
    } else if (commandLower == 'help') {
      await state.saveCommand(
        command,
        'Available commands:\n'
        '• flutter build ios --release - Build iOS app\n'
        '• flutter build apk --release - Build Android app\n'
        '• clear - Clear terminal and history\n'
        '• history - Show all command history\n'
        '• help - Show this help',
        true,
      );
    } else {
      await state.saveCommand(
        command,
        'Unknown command. Type "help" for available commands',
        false,
      );
    }

    _commandController.clear();
    state.resetHistoryIndex();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildBuildingState(TerminalState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTerminalPrompt('~/mobile-projects'),
            SizedBox(height: 8),
            _buildTerminalText(
              '\$ flutter build ${state.selectedPlatform} --release',
              color: Color(0xFF4EC9B0),
            ),
            SizedBox(height: 24),
            ...state.buildLogs.map(
              (log) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _buildTerminalText(log),
              ),
            ),
            SizedBox(height: 16),
            _buildProgressBar(state),
            SizedBox(height: 24),
            _buildTerminalPrompt('~/mobile-projects', showCursor: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(TerminalState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTerminalText(
          'Building ${state.selectedPlatform == 'ios' ? 'iOS' : 'Android'} application...',
        ),
        SizedBox(height: 8),
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: state.buildProgress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(state.buildProgress * 100).toInt()}%',
                  style: GoogleFonts.courierPrime(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteState(TerminalState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTerminalPrompt('~/mobile-projects'),
            SizedBox(height: 8),
            _buildTerminalText(
              '\$ flutter build ${state.selectedPlatform} --release',
              color: Color(0xFF4EC9B0),
            ),
            SizedBox(height: 24),
            ...state.buildLogs.map(
              (log) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _buildTerminalText(log),
              ),
            ),
            SizedBox(height: 16),
            _buildTerminalText('═' * 50, color: Colors.green),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                _buildTerminalText('Build succeeded!', color: Colors.green),
              ],
            ),
            SizedBox(height: 16),
            _buildTerminalText(
              'Built ${state.selectedPlatform == 'ios' ? 'Runner.app' : 'app-release.apk'}',
            ),
            _buildTerminalText(
              'Output: build/${state.selectedPlatform}/${state.selectedPlatform == 'ios' ? 'iphoneos/Runner.app' : 'app-release.apk'}',
              color: Colors.white70,
            ),
            _buildTerminalText('Size: 42.3 MB', color: Colors.white70),
            SizedBox(height: 24),
            _buildTerminalText(
              'Launching ${state.selectedPlatform == 'ios' ? 'iOS' : 'Android'} Simulator...',
            ),
            _buildTerminalText(
              'Starting ${state.selectedPlatform == 'ios' ? 'iPhone 15 Pro' : 'Pixel 8 Pro'} simulator...',
              color: Colors.cyan,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('⏳', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                _buildTerminalText(
                  'Simulator launching...',
                  color: Colors.yellow,
                ),
              ],
            ),
            SizedBox(height: 24),
            _buildTerminalPrompt('~/mobile-projects', showCursor: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorState(TerminalState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📱', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          _buildTerminalText(
            '${state.selectedPlatform == 'ios' ? 'iPhone 15 Pro' : 'Pixel 8 Pro'} Simulator',
            color: Colors.cyan,
          ),
          SizedBox(height: 8),
          _buildTerminalText('(Phone UI coming next)', color: Colors.white70),
        ],
      ),
    );
  }

  void _startBuild(String platform) async {
    final state = context.read<TerminalState>();
    state.startBuild(platform);
    await _simulateBuildProcess(state);
  }

  Future<void> _simulateBuildProcess(TerminalState state) async {
    state.addLog('Running "flutter pub get" in mobile-projects...');
    await Future.delayed(Duration(milliseconds: 500));
    state.addLog('✓ Dependencies resolved');
    state.updateProgress(0.2);
    await Future.delayed(Duration(milliseconds: 300));

    if (state.selectedPlatform == 'ios') {
      state.addLog('Analyzing dependencies...');
      await Future.delayed(Duration(milliseconds: 500));
      state.addLog('✓ Pod install complete');
    } else {
      state.addLog('Running Gradle task assembleRelease...');
      await Future.delayed(Duration(milliseconds: 500));
      state.addLog('✓ Gradle build complete');
    }
    state.updateProgress(0.4);
    await Future.delayed(Duration(milliseconds: 300));

    state.addLog(
      '○ Compiling ${state.selectedPlatform == 'ios' ? 'Swift' : 'Kotlin'} files...',
    );
    state.updateProgress(0.6);
    await Future.delayed(Duration(milliseconds: 800));
    state.replaceLastLog('○', '✓');

    state.addLog('○ Linking framework...');
    state.updateProgress(0.75);
    await Future.delayed(Duration(milliseconds: 600));
    state.replaceLastLog('○', '✓');

    state.addLog('○ Code signing...');
    state.updateProgress(0.85);
    await Future.delayed(Duration(milliseconds: 500));
    state.replaceLastLog('○', '✓');

    state.addLog(
      '○ Generating ${state.selectedPlatform == 'ios' ? '.app' : '.apk'} bundle...',
    );
    state.updateProgress(1.0);
    await Future.delayed(Duration(milliseconds: 500));
    state.replaceLastLog('○', '✓');

    await Future.delayed(Duration(milliseconds: 500));
    state.completeBuild();

    await Future.delayed(Duration(seconds: 2));
    state.launchSimulator();
  }

  // ============================================================
  // HELPER WIDGETS
  // ============================================================
  Widget _buildTerminalPrompt(String path, {bool showCursor = false}) {
    return Row(
      children: [
        _buildTerminalText('dhyaan@portfolio ', color: Colors.green),
        _buildTerminalText(path, color: Colors.blue),
        _buildTerminalText(' % ', color: Colors.white),
        if (showCursor) Container(width: 8, height: 16, color: Colors.white),
      ],
    );
  }

  Widget _buildComment(String text) =>
      _buildTerminalText(text, color: Colors.grey);

  Widget _buildTerminalText(String text, {Color? color}) {
    return SelectableText(
      text,
      style: GoogleFonts.courierPrime(
        color: color ?? Colors.white,
        fontSize: 13,
      ),
    );
  }
}
