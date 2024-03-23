import 'dart:async';

import 'package:spotify_app_prueba/models/artist_model.dart';
import 'package:spotify_app_prueba/services/artist_service.dart';

class ArtistApiProvider {
  final artistService = ArtistService();

  Future<ListArtist> getArtist() async {
    return await artistService.getFollowedArtists();
  }
}
