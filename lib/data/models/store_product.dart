

class StoreProduct {
  final String storeId;
  final List<Product> products;

  StoreProduct({
    required this.storeId,
    required this.products,
  });

  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    return StoreProduct(
      storeId: json['store_id']?.toString() ?? '',
      products: (json['products'] as List?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool availableForSale;
  final String currency;
  final String price;
  final String quantity;
  final String regularPrice;
  final String sku;
  final String storeType;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.availableForSale,
    required this.currency,
    required this.price,
    required this.quantity,
    required this.regularPrice,
    required this.sku,
    required this.storeType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      availableForSale: json['available_for_sale'] ?? false,
      currency: json['currency']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '',
      regularPrice: json['regular_price']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      storeType: json['store_type']?.toString() ?? '',
    );
  }
}
