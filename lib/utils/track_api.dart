import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_app_prueba/models/auth_model.dart';
import 'package:spotify_app_prueba/models/track_model.dart';

class TracksPlaylistApiProvider {
  Client client = Client();

  Future<TracksPlaylistModel> fetchTracks(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String? token_type = prefs.getString('token_type');

    String AuthorizationWithToken = '${token_type} ${access_token}';
    var response = await client.get(Uri.parse(url),
        headers: {'Authorization': AuthorizationWithToken});
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
        'redirect_uri': 'alarmfy:/'
      }, headers: {
        'Authorization': Authorization
      });

      if (responseNewToken.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        AuthorizationModel aM =
            AuthorizationModel.fromJson(json.decode(responseNewToken.body));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', aM.accessToken);
        prefs.setString('token_type', aM.tokenType);
        prefs.setBool('logged', true);

        access_token = prefs.getString('access_token')!;
        token_type = prefs.getString('token_type')!;
        String AuthorizationWithToken = '${token_type} ${access_token}';
        response = await client.get(Uri.parse(url),
            headers: {'Authorization': AuthorizationWithToken});
        print("Se dio un nuevo token!");
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to request a new token');
      }
    }

    if (response.statusCode == 200) {
      return TracksPlaylistModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tracks');
    }
  }
}
