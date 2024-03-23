import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:spotify_app_prueba/models/profile_model.dart';

class ProfileService {
  Client client = Client();
  var baseUrl = 'https://api.spotify.com/v1/me';

  final BehaviorSubject<List<dynamic>> _searchResultsSubject =
      BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get searchResultsStream => _searchResultsSubject.stream;

  Future<SpotifyUser> getDataprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String? token_type = prefs.getString('token_type');

    String AuthorizationWithToken = '${token_type} ${access_token}';
    var response = await client.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': AuthorizationWithToken},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return SpotifyUser.fromJson(data);
    } else {
      throw Exception('Failed to load user information');
    }
  }
}
