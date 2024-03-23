import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/services/playlist_service.dart';
import 'package:spotify_app_prueba/models/playlist_model.dart';
import 'package:spotify_app_prueba/models/track_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TracksScreen extends StatefulWidget {
  @override
  _TracksScreenState createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  late Playlist _playlist;
  AudioPlayer audioPlayer = AudioPlayer();
  bool sound = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _playlist = Playlist();
  }

  play(String url) async {
    await audioPlayer.play(UrlSource(url));
    sound = true;
  }

  _launchURL(urlParameter) async {
    String url = urlParameter.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo ir a $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments != null) {
      _playlist = arguments['playlist'] as Playlist;
      playlistBloc.fetchTracksList(_playlist.tracks!.href.toString());
    }

    SliverAppBar sliverAppBar = new SliverAppBar(
      backgroundColor: Color(0xff1ed760),
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        centerTitle: true,
        title: Text("${_playlist.name}"),
        background: Stack(
          alignment: Alignment.center,
          //fit: StackFit.expand, // Para expandir la imagen por
          children: [
            Image.network(
              "${_playlist.images!.length > 0 ? _playlist.images![0].url : "https://cdn.pixabay.com/photo/2012/04/23/15/46/question-38629_960_720.png"}",
              height: 180,
              //fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.5),
                  end: Alignment(0.0, 0.0),
                  colors: <Color>[
                    Color(0x60000000),
                    Color(0x00000000),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    _sliverList(AsyncSnapshot<TracksPlaylistModel> snapshot) {
      SliverList sliverList = SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    label: 'Open Spotify',
                    foregroundColor: Color(0xff1ed760),
                    backgroundColor: Colors.black,
                    icon: Icons.exit_to_app_sharp,
                    onPressed: (context) {
                      _launchURL(snapshot
                          .data!.items[index].track!.externalUrls.spotify);
                    },
                  ),
                ],
              ),
              //actionExtentRatio: 0.25,
              child: Container(
                //color: Theme.of(context).primaryColor,
                color: Colors.black,
                child: ListTile(
                  leading: Image.network(snapshot
                              .data!.items[index].track!.album.images.length >
                          0
                      ? snapshot.data!.items[index].track!.album.images[0].url
                      : "https://cdn.pixabay.com/photo/2012/04/23/15/46/question-38629_960_720.png"),
                  title: Text(
                    "${snapshot.data!.items[index].track!.name}",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "${snapshot.data!.items[index].track!.artists[0].name}",
                    style: TextStyle(color: Colors.white54),
                  ),
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    play(snapshot.data!.items[index].track!.previewUrl!);
                  },
                ),
              ),
            );
          },
          childCount: snapshot.data!.total,
        ),
      );
      return sliverList;
    }

    _scaffold(AsyncSnapshot<TracksPlaylistModel> snapshot) {
      Scaffold scaffold = Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[sliverAppBar, _sliverList(snapshot)],
        ),
      );
      return scaffold;
    }

    return StreamBuilder(
      stream: playlistBloc.tracksList,
      builder: (context, AsyncSnapshot<TracksPlaylistModel> snapshot) {
        if (snapshot.hasData) {
          return _scaffold(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          color: Color(0xff1ed760),
        ));
      },
    );
  }
}
