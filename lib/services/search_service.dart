import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_app_prueba/models/auth_model.dart';

class SearchService {
  Client client = Client();
  var baseUrl = 'https://api.spotify.com/v1/search';
  final BehaviorSubject<List<dynamic>> _searchResultsSubject =
      BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get searchResultsStream => _searchResultsSubject.stream;

  Future<void> search(String query, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String? token_type = prefs.getString('token_type');

    String AuthorizationWithToken = '${token_type} ${access_token}';

    final response = await client.get(
      Uri.parse('$baseUrl?q=$query&type=$type'),
      headers: {'Authorization': AuthorizationWithToken},
    );
    if (response.statusCode == 401) {
      String? refresh_token = prefs.getString('refresh_token');
      String client_id = "9cd76c6775744418af7e25c0ab9a4268";
      String client_secret = "56aef8512dfa40c996f8cfecbb23d132";
      String AuthorizationStr = "$client_id:$client_secret";
      var bytes = utf8.encode(AuthorizationStr);
      var base64Str = base64.encode(bytes);
      String Authorization = 'Basic ' + base64Str;
      var responseNewToken = await client
          .post(Uri.parse("https://accounts.spotify.com/api/token"), body: {
        'grant_type': 'refresh_token',
        'refresh_token': refresh_token,
        'redirect_uri': 'my.music.app://callback'
      }, headers: {
        'Authorization': Authorization
      });
      if (responseNewToken.statusCode == 200) {
        print(responseNewToken.body);
        AuthorizationModel aM =
            AuthorizationModel.fromJson(json.decode(responseNewToken.body));
        String AuthorizationWithToken = '${aM.tokenType} ${aM.accessToken}';
        final response = await client.get(
          Uri.parse('$baseUrl?q=$query&type=$type'),
          headers: {'Authorization': AuthorizationWithToken},
        );
        print("Se dio un nuevo token 3");

        print(response);
      } else {
        throw Exception('Failed to request a new token');
      }
    }

    if (response.statusCode == 200) {
      final searchResults =
          json.decode(response.body)['${type}s']['items'] as List<dynamic>;
      _searchResultsSubject.add(searchResults);
    } else {
      print(response.body);
    }
  }

  void dispose() {
    _searchResultsSubject.close();
  }
}
