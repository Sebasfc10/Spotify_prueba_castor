class SpotifyUser {
  final String displayName;
  final String spotifyUrl;
  final String href;
  final String id;
  final List<UserImage> images;
  final String type;
  final String uri;
  final Follower followers;
  final String? country;
  final String? product;
  final ExplicitContent? explicitContent;
  final String? email;

  SpotifyUser({
    required this.displayName,
    required this.spotifyUrl,
    required this.href,
    required this.id,
    required this.images,
    required this.type,
    required this.uri,
    required this.followers,
    this.country,
    this.product,
    this.explicitContent,
    this.email,
  });
  factory SpotifyUser.fromJson(Map<String, dynamic> json) {
    return SpotifyUser(
      displayName: json['display_name'],
      spotifyUrl: json['external_urls']['spotify'],
      href: json['href'],
      id: json['id'],
      images: List<UserImage>.from(
          json['images'].map((x) => UserImage.fromJson(x))),
      type: json['type'],
      uri: json['uri'],
      followers: Follower.fromJson(json['followers']),
      country: json['country'],
      product: json['product'],
      explicitContent: json['explicit_content'] != null
          ? ExplicitContent.fromJson(json['explicit_content'])
          : null,
      email: json['email'],
    );
  }
}

class UserImage {
  final String? url;
  final int? height;
  final int? width;

  UserImage({
    this.url,
    this.height,
    required this.width,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      url: json['url'],
      height: json['height'],
      width: json['width'],
    );
  }
}

class Follower {
  final String? href;
  final int? total;

  Follower({
    this.href,
    this.total,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      href: json['href'],
      total: json['total'],
    );
  }
}

class ExplicitContent {
  final bool? filterEnabled;
  final bool? filterLocked;

  ExplicitContent({
    this.filterEnabled,
    this.filterLocked,
  });

  factory ExplicitContent.fromJson(Map<String, dynamic> json) {
    return ExplicitContent(
      filterEnabled: json['filter_enabled'],
      filterLocked: json['filter_locked'],
    );
  }
}
