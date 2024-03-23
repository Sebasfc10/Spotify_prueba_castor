import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/services/search_service.dart';
import 'package:spotify_app_prueba/models/playlist_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  SearchService _searchService = SearchService();
  List<dynamic> _searchResults = [];
  late Playlist _playlist;
  AudioPlayer audioPlayer = AudioPlayer();
  bool sound = false;

  @override
  void initState() {
    super.initState();
    _searchService.searchResultsStream.listen((results) {
      setState(() {
        _searchResults = results;
      });
    });
  }

  play(String url) async {
    await audioPlayer.play(UrlSource(url));
    sound = true;
  }

  @override
  void dispose() {
    _searchService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.white),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  focusColor: Colors.black,
                  hintText: 'Buscar',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff1ed760), // Color de fondo verde
                  shape: RoundedRectangleBorder(
                    // Forma rectangular
                    borderRadius: BorderRadius.circular(
                        20), // Ajusta el radio según tu preferencia
                  ),
                ),
                onPressed: () =>
                    _searchService.search(_searchController.text, 'track'),
                child: Text(
                  'Pistas',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff1ed760), // Color de fondo verde
                  shape: RoundedRectangleBorder(
                    // Forma rectangular
                    borderRadius: BorderRadius.circular(
                        20), // Ajusta el radio según tu preferencia
                  ),
                ),
                onPressed: () =>
                    _searchService.search(_searchController.text, 'album'),
                child: Text(
                  'Álbumes',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff1ed760), // Color de fondo verde
                  shape: RoundedRectangleBorder(
                    // Forma rectangular
                    borderRadius: BorderRadius.circular(
                        20), // Ajusta el radio según tu preferencia
                  ),
                ),
                onPressed: () =>
                    _searchService.search(_searchController.text, 'artist'),
                child: Text(
                  'Artistas',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  leading: _searchController.text.isNotEmpty &&
                          _searchController.text.toLowerCase() == 'artist'
                      ? result['images'] != null && result['images'].isNotEmpty
                          ? SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                result['images'][0]
                                    ['url'], // URL de la imagen del artista
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(
                              width:
                                  50) // Si no hay imagen de artista, mostrar un SizedBox con un ancho específico
                      : result['album'] != null &&
                              result['album']['name'] != null &&
                              result['album']['images'].isNotEmpty
                          ? SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                result['album']['images'][0]
                                    ['url'], // URL de la imagen del álbum
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(
                              width:
                                  50), // Si no hay imagen de álbum, mostrar un SizedBox con un ancho específico
                  title: Text(
                    result['name'] ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _searchController.text.isNotEmpty &&
                            _searchController.text.toLowerCase() == 'track'
                        ? '${result['name'] ?? ''} - ${result['artists'][0]['name'] ?? ''}'
                        : (result['artists'] != null &&
                                result['artists'].isNotEmpty
                            ? result['artists'][0]['name']
                            : ''),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print(result['item']);
                    play(result['preview_url']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
