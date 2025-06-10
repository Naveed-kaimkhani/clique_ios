class PopstreamProduct {
  final String id;
  final String productTitle;
  final List<String> imageUrls;

  PopstreamProduct({
    required this.id,
    required this.productTitle,
    required this.imageUrls,
  });

  factory PopstreamProduct.fromJson(Map<String, dynamic> json) {
    return PopstreamProduct(
      id: json['id'] ?? '',
      productTitle: json['name'] ?? '',
      imageUrls: json['images'] != null && (json['images'] as List).isNotEmpty
          ? List<String>.from(json['images'])
          : [json['productUrl'] ?? ''], // fallback to productUrl if images is empty
    );
  }
}
