import 'dart:async';
import 'package:spotify_app_prueba/models/artist_model.dart';
import 'package:spotify_app_prueba/models/auth_model.dart';
import 'package:spotify_app_prueba/models/playlist_model.dart';
import 'package:spotify_app_prueba/models/profile_model.dart';
import 'package:spotify_app_prueba/models/track_model.dart';
import 'package:spotify_app_prueba/utils/artist_api_provider.dart';
import 'package:spotify_app_prueba/utils/auth_api_provider.dart';
import 'package:spotify_app_prueba/utils/auth_token_provider.dart';
import 'package:spotify_app_prueba/utils/playlist_api_provider.dart';
import 'package:spotify_app_prueba/utils/profile_api_provider.dart';
import 'package:spotify_app_prueba/utils/search_api_provider.dart';
import 'package:spotify_app_prueba/utils/track_api.dart';

class RepositoryAuthorization {
  final authorizationCodeApiProvider = AuthorizationApiProvider();
  final authorizationTokenApiProvider = AuthorizationTokenApiProvider();
  Future<String?> fetchAuthorizationCode() =>
      authorizationCodeApiProvider.fetchCode();
  Future<AuthorizationModel> fetchAuthorizationToken(String code) =>
      authorizationTokenApiProvider.fetchToken(code);
}

class RepositoryPlaylist {
  final playlistsListApiProvider = PlaylistListApiProvider();
  final tracksPlaylistApiProvider = TracksPlaylistApiProvider();
  Future<ListPlaylistModel> fetchPlaylistList() =>
      playlistsListApiProvider.fetchPlaylistList();
  Future<TracksPlaylistModel> fetchTracksList(String url) =>
      tracksPlaylistApiProvider.fetchTracks(url);
}

class RepositorySearch {
  final searchApiProvider = SearchApiProvider();
  Future<void> search(String query, String type) =>
      searchApiProvider.search(query, type);
}

class RepositoryArtist {
  final searchApiProvider = ArtistApiProvider();
  Future<ListArtist> search() => searchApiProvider.getArtist();
}

class RepositoryProfile {
  final profileApiProvider = ProfileApiProvider();
  Future<SpotifyUser> getProfile() => profileApiProvider.getProfile();
}
