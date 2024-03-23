import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/services/playlist_service.dart';
import 'package:spotify_app_prueba/models/playlist_model.dart';

class PlaylistTab extends StatefulWidget {
  @override
  _PlaylistTabState createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<PlaylistTab> {
  @override
  void initState() {
    super.initState();
    playlistBloc.fetchPlaylistList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ListPlaylistModel>(
      stream: playlistBloc.playlistList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.total,
            itemBuilder: (BuildContext context, int index) {
              final playlist = snapshot.data!.items[index];
              return ListTile(
                leading: Image.network(
                  playlist.images!.isNotEmpty
                      ? playlist.images![0].url
                      : "https://cdn.pixabay.com/photo/2012/04/23/15/46/question-38629_960_720.png",
                ),
                title: Text(
                  playlist.name!,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "de ${playlist.owner!.id}",
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/tracks",
                      arguments: <String, Playlist>{'playlist': playlist});
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
