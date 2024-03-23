import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/models/track_model.dart';
import 'package:spotify_app_prueba/services/recommend_service.dart';

class StartPage extends StatefulWidget {
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  final RecommendationService recommendationService = RecommendationService();
  List<Track> tracks = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      List<Track> recommendedTracks =
          await recommendationService.fetchRecommendations();
      setState(() {
        tracks = recommendedTracks;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recomendaciones',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                var track = tracks[index];
                return ListTile(
                  title: Text(
                    track.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    track.album.name,
                    style: TextStyle(color: Colors.grey),
                  ),
                  leading: Image.network(
                    track.album.images[0].url,
                    width: 50,
                    height: 50,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
