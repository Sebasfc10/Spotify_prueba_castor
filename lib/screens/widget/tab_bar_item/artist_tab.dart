import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/models/artist_model.dart';
import 'package:spotify_app_prueba/services/artist_service.dart';

class ArtistTab extends StatefulWidget {
  @override
  State<ArtistTab> createState() => _ArtistTabState();
}

class _ArtistTabState extends State<ArtistTab> {
  ArtistService _artistService = ArtistService();
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _artistService.searchResultsStream.listen((event) {
      setState(() {
        _searchResults = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<ListArtist>(
        future: _artistService.getFollowedArtists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Artist> artists = snapshot.data?.artists ?? [];
            return ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) {
                final artist = artists[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(artist.imageUrl.isNotEmpty
                        ? artist.imageUrl
                        : ''), // Aquí asumo que la lista de imágenes no está vacía
                  ),
                  title: Text(
                    artist.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Followers: ${artist.followers}',
                    style: TextStyle(color: Colors.white30),
                  ),
                  onTap: () {
                    // Do something when artist is tapped
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
