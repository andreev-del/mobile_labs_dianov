import 'dart:io';
import 'package:logging/logging.dart';

/// Инициализирует логгер с записью в файл
Logger initFileLogger(String name) {
  hierarchicalLoggingEnabled = true;
  final logger = Logger(name);
  final now = DateTime.now();

  // Находим корневую папку проекта
  final scriptFile = File(Platform.script.toFilePath());
  final projectDir = scriptFile.parent.parent.path;

  // Создаём папку logs
  final dir = Directory('$projectDir/logs');
  if (!dir.existsSync()) dir.createSync();

  // Создаём файл лога с уникальным именем
  final logFile = File(
    '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
  );

  // Уровень логирования (ALL для разработки)
  logger.level = Level.ALL;

  // Записываем каждое сообщение в файл
  logger.onRecord.listen((record) {
    final msg =
        '[${record.time} - ${record.loggerName}] ${record.level.name}: ${record.message}';
    logFile.writeAsStringSync('$msg \n', mode: FileMode.append);
  });

  return logger;
}