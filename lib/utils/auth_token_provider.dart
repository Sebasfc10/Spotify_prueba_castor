import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:spotify_app_prueba/models/auth_model.dart';

class AuthorizationTokenApiProvider {
  Client client = Client();
  static String client_id = "9cd76c6775744418af7e25c0ab9a4268";
  static String client_secret = "56aef8512dfa40c996f8cfecbb23d132";

  static String AuthorizationStr = "$client_id:$client_secret";
  static var bytes = utf8.encode(AuthorizationStr);
  static var base64Str = base64.encode(bytes);

  String Authorization = 'Basic ' + base64Str;

  var urlToToken = 'https://accounts.spotify.com/api/token';

  Future<AuthorizationModel> fetchToken(String code) async {
    var response = await client.post(Uri.parse(urlToToken), body: {
      'grant_type': "authorization_code",
      'code': code,
      'redirect_uri': 'my.music.app://callback'
    }, headers: {
      'Authorization': Authorization
    });

    if (response.statusCode == 200) {
      print('se logueo');
      return AuthorizationModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
