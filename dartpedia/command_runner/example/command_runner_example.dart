import 'dart:async';
import 'package:command_runner/command_runner.dart';

// Команда echo с цветными словами
class PrettyEcho extends Command {
  PrettyEcho() {
    addFlag('blue-only', abbr: 'b', help: 'Всё будет синим');
  }

  @override
  String get name => 'echo';
  @override
  bool get requiresArgument => true;
  @override
  String get description => 'Печатает текст с цветами';
  @override
  String? get help => 'Каждое слово красится в свой цвет';
  @override
  String? get valueHelp => 'ТЕКСТ';

  @override
  FutureOr<String> run(ArgResults arg) {
    if (arg.commandArg == null) {
      throw ArgumentException('Нужен один аргумент', name);
    }

    final words = arg.commandArg!.split(' ');
    final prettyWords = <String>[];

    for (var i = 0; i < words.length; i++) {
      switch (i % 3) {
        case 0:
          prettyWords.add(words[i].titleText);      // голубой
        case 1:
          prettyWords.add(words[i].instructionText); // жёлтый
        case 2:
          prettyWords.add(words[i].errorText);       // красный
      }
    }
    return prettyWords.join(' ');
  }
}

void main(List<String> arguments) {
  final runner = CommandRunner()..addCommand(PrettyEcho());
  runner.run(arguments);
}
