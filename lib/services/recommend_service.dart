import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:spotify_app_prueba/models/track_model.dart';

class RecommendationService {
  Client client = Client();
  var apiUrl = 'https://api.spotify.com/v1/recommendations';

  final BehaviorSubject<List<dynamic>> _searchResultsSubject =
      BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get searchResultsStream => _searchResultsSubject.stream;

  Future<List<Track>> fetchRecommendations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String? token_type = prefs.getString('token_type');

    String AuthorizationWithToken = '${token_type} ${access_token}';

    final Map<String, dynamic> queryParams = {
      'limit': '100',
      'seed_artists': '2P3hIDJeVR6tUceKJJ8dUV',
      'seed_tracks': '0c6xIDDpzE81m2q797ordA',
      'seed_genres': 'reggaeton,trap latino,urbano latino',
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    var response = await client.get(
      uri,
      headers: {
        'Authorization': AuthorizationWithToken,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['tracks'];
      List<Track> tracks =
          responseData.map((data) => Track.fromJson(data)).toList();
      return tracks;
    } else {
      print('Error al obtener recomendaciones: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to fetch recommendations');
    }
  }
}
