class Artist {
  final String name;
  final String id;
  final String imageUrl;
  final int followers;
  final List<String> genres;

  Artist({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.followers,
    required this.genres,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      id: json['id'],
      imageUrl: json['images'][0]
          ['url'], // Assuming there's always at least one image
      followers: json['followers']['total'],
      genres: List<String>.from(json['genres']),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "images": imageUrl[0],
        "followers": followers,
        "genres": genres[0]
      };
}

class ListArtist {
  List<Artist> artists;

  ListArtist({
    required this.artists,
  });
  factory ListArtist.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists']['items'] as List;
    List<Artist> artists =
        artistList.map((artistJson) => Artist.fromJson(artistJson)).toList();
    return ListArtist(artists: artists);
  }

  Map<String, dynamic> toJson() =>
      {"artists": List<dynamic>.from(artists.map((e) => e.toJson()))};
}
