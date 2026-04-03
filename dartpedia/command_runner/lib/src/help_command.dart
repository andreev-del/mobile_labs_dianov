import 'dart:async';

import 'package:command_runner/command_runner.dart';

import 'console.dart';
import 'exceptions.dart';

/// Команда для отображения справки с поддержкой подробного вывода.
class HelpCommand extends Command {
  HelpCommand() {
    addFlag('verbose', abbr: 'v', help: 'Показывает подробную справку (опции команд)');
    addOption('command', abbr: 'c', help: 'Показывает справку только по указанной команде');
  }

  @override
  String get name => 'help';

  @override
  String get description => 'Показывает справку по использованию';

  @override
  String? get help => 'Показывает это сообщение';

  @override
  FutureOr<String> run(ArgResults args) async {
    final buffer = StringBuffer();

    // Заголовок
    buffer.writeln(runner.usage.titleText);

    // Подробный вывод всех команд
    if (args.flag('verbose')) {
      for (var cmd in runner.commands) {
        buffer.write(_renderCommandVerbose(cmd));
      }
      return buffer.toString();
    }

    // Справка по конкретной команде
    if (args.hasOption('command')) {
      final input = args.getOption('command').input;
      final cmd = runner.commands.firstWhere(
        (command) => command.name == input,
        orElse: () {
          throw ArgumentException(
            'Команда "$input" не найдена.',
            name,
            input as String?,
          );
        },
      );
      return _renderCommandVerbose(cmd);
    }

    // Обычный краткий вывод
    for (var command in runner.commands) {
      buffer.writeln(command.usage);
    }

    return buffer.toString();
  }

  /// Форматирует подробную справку для одной команды
  String _renderCommandVerbose(Command cmd) {
    final indent = ' ' * 10;  // убрали const
    final buffer = StringBuffer();

    // Название и описание
    buffer.writeln(cmd.usage.instructionText);

    // Подробное описание (если есть)
    if (cmd.help != null) {
      buffer.writeln('$indent ${cmd.help}');
    }

    // Информация об аргументе
    if (cmd.valueHelp != null) {
      buffer.writeln(
        '$indent 📌 Аргумент: ${cmd.valueHelp}, обязательный: ${cmd.requiresArgument}, по умолчанию: ${cmd.defaultValue ?? 'нет'}',
      );
    }

    // Список опций
    if (cmd.options.isNotEmpty) {
      buffer.writeln('$indent Опции:');
      for (var option in cmd.options) {
        buffer.writeln('$indent ${option.usage}');
      }
    }

    return buffer.toString();
  }
}