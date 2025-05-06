class ProductModel {
  final int id;
  final String productTitle;
  final String productDesc;
  final String brandName;
  var cost;
  var msrp;
  final List<String> imageUrls;
  final String thumbnailUrl;
   final String unit;
  final String productWeight;
  final String? categories; // New field for categories
  final String? variantGroupId;
  final String? tdid; // New field for tdid
  final String? productCode; // New field for product_code

  ProductModel({
    required this.id,
    required this.productWeight,
    required this.productTitle,
    required this.productDesc,
    required this.brandName,
    required this.unit,
    required this.cost,
    required this.msrp,
    required this.imageUrls,
    required this.thumbnailUrl,
    required this.categories, // Initialize categories in constructor
     this.variantGroupId,
    this.tdid, // Optional field for tdid
    this.productCode, // Optional field for product_code
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // final imageUrls = (json['image_url'] as String).split(',');
    final imageUrls = (json['image_url'] as String?)?.split(',') ?? [];

    final thumbnails = (json['thumbnail_url'] as String).split(',');
    final categories = json['categories'];

    return ProductModel(
      id: json['id'],
      unit: json['mass_unit'],
      productTitle: json['product_title'],      
      productWeight: json['product_weight'],
      productDesc: json['product_desc'],
      brandName: json['brand_name'],
      cost: json['cost'],
      msrp: json['msrp'],
      imageUrls: imageUrls,
      thumbnailUrl: thumbnails.isNotEmpty ? thumbnails.first : '',
      categories: categories, // Assign categories from JSON
      variantGroupId: json['variant_group_id'],
      tdid: json['tdid'], // Assign tdid from JSON
      productCode: json['product_code'], // Assign product_code from JSON
      // type: json['type'], // Assign type from JSON
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'pid': id,
      'product_title': productTitle,
      'product_desc': productDesc,
      'price': cost,
      'product_image': imageUrls.join(','), 
      'product_code': productCode, 
    };
  }
}
