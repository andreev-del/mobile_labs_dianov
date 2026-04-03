import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:wikipedia/src/model/article.dart';
import 'package:wikipedia/src/model/search_results.dart';
import 'package:wikipedia/src/model/summary.dart';

const String dartLangSummaryJson = './test/test_data/dart_lang_summary.json';
const String catExtractJson = './test/test_data/cat_extract.json';
const String openSearchResponse = './test/test_data/open_search_response.json';

void main() {
  group('Десериализация JSON ответов от Wikipedia API', () {
    
    test('Десериализация статьи о Dart в объект Summary', () async {
      // Читаем JSON файл
      final String pageSummaryInput =
          await File(dartLangSummaryJson).readAsString();
      final Map<String, Object?> pageSummaryMap =
          jsonDecode(pageSummaryInput) as Map<String, Object?>;
      
      // Создаём объект Summary
      final Summary summary = Summary.fromJson(pageSummaryMap);
      
      // Проверяем, что canonical заголовок правильный
      expect(summary.titles.canonical, 'Dart_(programming_language)');
    });

    test('Десериализация статьи о коте в объект Article', () async {
      final String articleJson = await File(catExtractJson).readAsString();
      final Map<String, Object?> articleMap =
          jsonDecode(articleJson) as Map<String, Object?>;
      
      final List<Article> articles = Article.listFromJson(articleMap);
      
      expect(articles.first.title.toLowerCase(), 'cat');
    });

    test('Десериализация результатов поиска в объект SearchResults', () async {
      final String resultsString =
          await File(openSearchResponse).readAsString();
      final List<Object?> resultsAsList =
          jsonDecode(resultsString) as List<Object?>;
      
      final SearchResults results = SearchResults.fromJson(resultsAsList);
      
      expect(results.results.length, greaterThan(1));
    });
  });
}