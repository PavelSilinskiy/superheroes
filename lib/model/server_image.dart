class ServerImage {
  final String url;

  ServerImage({required this.url});

  factory ServerImage.fromJson(Map<String, dynamic> json) {
    return ServerImage(url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}