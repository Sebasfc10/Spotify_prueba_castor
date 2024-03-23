import 'package:rxdart/rxdart.dart';
import 'package:spotify_app_prueba/models/playlist_model.dart';
import 'package:spotify_app_prueba/models/track_model.dart';
import 'package:spotify_app_prueba/utils/repository.dart';

class PlaylistBloc {
  final _repository = RepositoryPlaylist();

  final _playlistListFetcher = PublishSubject<ListPlaylistModel>();
  final _tracksListFetcher = PublishSubject<TracksPlaylistModel>();

  Stream<ListPlaylistModel> get playlistList => _playlistListFetcher.stream;
  Stream<TracksPlaylistModel> get tracksList => _tracksListFetcher.stream;

  void fetchPlaylistList() async {
    try {
      final playlist = await _repository.fetchPlaylistList();
      _playlistListFetcher.sink.add(playlist);
    } catch (e) {
      _playlistListFetcher.sink.addError(e);
    }
  }

  void fetchTracksList(String url) async {
    try {
      final tracks = await _repository.fetchTracksList(url);
      _tracksListFetcher.sink.add(tracks);
    } catch (e) {
      _tracksListFetcher.sink.addError(e);
    }
  }

  void dispose() {
    _playlistListFetcher.close();
    _tracksListFetcher.close();
  }
}

final playlistBloc = PlaylistBloc();
