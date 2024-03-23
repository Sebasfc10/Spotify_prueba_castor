import 'dart:async';
import 'package:spotify_app_prueba/models/profile_model.dart';
import 'package:spotify_app_prueba/services/profile_service.dart';

class ProfileApiProvider {
  final profileService = ProfileService();

  Future<SpotifyUser> getProfile() async {
    return await profileService.getDataprofile();
  }
}
