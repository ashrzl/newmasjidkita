class Video {
  final int id;
  final String title;
  final String url;
  final String image;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      image: json['image'],
    );
  }
}
