import 'dart:async';
import 'dart:io';

import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

class GetArticleCommand extends Command {
  GetArticleCommand({required this.logger});

  final Logger logger;

  @override
  String get description => 'Читает статью из Wikipedia';

  @override
  String get name => 'article';

  @override
  String get help => 'Получает статью по точному названию';

  @override
  String get defaultValue => 'cat';

  @override
  String get valueHelp => 'НАЗВАНИЕ_СТАТЬИ';

  @override
  FutureOr<String> run(ArgResults args) async {
    try {
      final title = args.commandArg ?? defaultValue;
      final List<Article> articles = await getArticleByTitle(title);
      final article = articles.first;

      final buffer = StringBuffer('\n=== ${article.title.titleText} ===\n\n');
      buffer.write(article.extract.split(' ').take(500).join(' '));
      buffer.write('\n...\n');
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