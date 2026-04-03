import 'dart:async';
import 'arguments.dart';

class HelpCommand extends Command {
  HelpCommand() {
    addFlag('verbose', abbr: 'v', help: 'When true, prints detailed usage.');
    addOption('command', abbr: 'c', help: 'Prints usage for a specific command.');
  }
  @override
  String get name => 'help';
  @override
  String get description => 'Prints usage information.';
  @override
  String? get help => 'Prints this usage information';

  @override
  FutureOr<Object?> run(ArgResults args) async {
    var usage = runner.usage;
    for (var command in runner.commands) {
      usage += '\n ${command.usage}';
    }
    return usage;
  }
}