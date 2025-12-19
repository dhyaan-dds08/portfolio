import 'package:json_annotation/json_annotation.dart';

part 'frontend_command_history.g.dart';

@JsonSerializable()
class FrontendCommandHistory {
  final String command;
  final DateTime timestamp;
  final String? output;
  final bool success;

  FrontendCommandHistory({
    required this.command,
    required this.timestamp,
    this.output,
    this.success = true,
  });

  factory FrontendCommandHistory.fromJson(Map<String, dynamic> json) =>
      _$FrontendCommandHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$FrontendCommandHistoryToJson(this);
}
