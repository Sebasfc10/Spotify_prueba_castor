import 'dart:async';
import 'package:spotify_app_prueba/services/search_service.dart';

class SearchApiProvider {
  final searchService = SearchService();

  Future<void> search(String query, String type) async {
    await searchService.search(query, type);
  }
}
