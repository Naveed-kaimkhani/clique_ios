class PopstreamProduct {
  final String id;
  final String productTitle;

  final String quantity;
  final List<String> imageUrls;

  PopstreamProduct({
    required this.quantity,
    required this.id,
    required this.productTitle,
    required this.imageUrls,
  });

  factory PopstreamProduct.fromJson(Map<String, dynamic> json) {
    List<String> imageList = [];

    if (json['images'] != null) {
      imageList =
          (json['images'] as List).map((img) => img['src'] as String).toList();
    }

    if (imageList.isEmpty && json['productUrl'] != null) {
      imageList = [json['productUrl']];
    }

    return PopstreamProduct(
      id: json['id'] ?? '',
      productTitle: json['name'] ?? '',
      quantity: json['quantity'],
      imageUrls: imageList,
    );
  }
}
