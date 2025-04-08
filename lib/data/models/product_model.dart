class ProductModel {
  final int id;
  final String productTitle;
  final String productDesc;
  final String brandName;
  final double cost;
  final double msrp;
  final List<String> imageUrls;
  final String thumbnailUrl;
  final String? categories; // New field for categories
  final String? variantGroupId;

  ProductModel({
    required this.id,
    required this.productTitle,
    required this.productDesc,
    required this.brandName,
    required this.cost,
    required this.msrp,
    required this.imageUrls,
    required this.thumbnailUrl,
    required this.categories, // Initialize categories in constructor
    required this.variantGroupId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imageUrls = (json['image_url'] as String).split(',');
    final thumbnails = (json['thumbnail_url'] as String).split(',');

    // Assuming the categories field is a string of comma-separated category names
    final categories = json['categories'];

    return ProductModel(
      id: json['id'],
      productTitle: json['product_title'],
      productDesc: json['product_desc'],
      brandName: json['brand_name'],
      cost: double.tryParse(json['cost']) ?? 0.0,
      msrp: double.tryParse(json['msrp']) ?? 0.0,
      imageUrls: imageUrls,
      thumbnailUrl: thumbnails.isNotEmpty ? thumbnails.first : '',
      categories: categories, // Assign categories from JSON
      variantGroupId: json['variant_group_id'],
    );
  }
}
