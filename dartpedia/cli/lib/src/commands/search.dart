import 'dart:async';
import 'dart:io';

import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

class SearchCommand extends Command {
  SearchCommand({required this.logger}) {
    addFlag(
      'im-feeling-lucky',
      help: 'Показывает краткое содержание первой найденной статьи',
    );
  }

  final Logger logger;

  @override
  String get description => 'Поиск статей в Wikipedia';

  @override
  bool get requiresArgument => true;

  @override
  String get name => 'search';

  @override
  String get valueHelp => 'СЛОВО_ДЛЯ_ПОИСКА';

  @override
  String get help => 'Ищет статьи по заданному слову';

  @override
  FutureOr<String> run(ArgResults args) async {
    if (args.commandArg == null || args.commandArg!.isEmpty) {
      return 'Пожалуйста, укажите поисковый запрос';
    }

    final buffer = StringBuffer('Результаты поиска:\n');

    try {
      final SearchResults results = await search(args.commandArg!);

      // "Мне повезёт" — показываем первую статью
      if (args.flag('im-feeling-lucky')) {
        final title = results.results.first.title;
        final Summary article = await getArticleSummaryByTitle(title);
        buffer.writeln('\n✨ Вам повезло! ✨\n');
        buffer.writeln(article.titles.normalized.titleText);
        if (article.description != null) {
          buffer.writeln(article.description);
        }
        buffer.writeln(article.extract);
        buffer.writeln('\n--- Все результаты ---\n');
      }

      for (var result in results.results) {
        buffer.writeln('📄 ${result.title} - ${result.url}');
      }
      return buffer.toString();
    } on HttpException catch (e) {
      logger
        ..warning(e.message)
        ..warning(e.uri.toString())
        ..info(usage);
      return 'Ошибка сети: ${e.message}';
    } on FormatException catch (e) {
      logger
        ..warning(e.message)
        ..warning(e.source ?? '')
        ..info(usage);
      return 'Ошибка формата данных: ${e.message}';
    }
  }
}