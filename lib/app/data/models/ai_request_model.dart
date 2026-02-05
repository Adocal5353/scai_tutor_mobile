class AiRequest {
  final String text;
  final double? temperature;
  final dynamic image;
  final String? imageUrl;

  AiRequest({
    required this.text,
    this.temperature,
    this.image,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'text': text,
    };

    if (temperature != null) {
      data['temperature'] = temperature;
    }
    if (imageUrl != null) {
      data['image_url'] = imageUrl;
    }

    return data;
  }
}
