class ShippingEstimate {
  final String tdid;
  final String phone;
  final String address1;
  final String street2;
  final String address2;
  final String zipCode;
  final String countryCode;
  final String country;
  final String provider;
  final String customerName;
  final String token;
  final double amount;
  final String currency;
  final int estimatedDays;
  final String? arrivesBy;
  final String durationTerms;
  final String providerImage75;
  final String providerImage200;

  ShippingEstimate({
    required this.tdid,
    required this.phone,
    required this.address1,
    required this.street2,
    required this.address2,
    required this.zipCode,
    required this.countryCode,
    required this.country,
    required this.provider,
    required this.customerName,
    required this.token,
    required this.amount,
    required this.currency,
    required this.estimatedDays,
    this.arrivesBy,
    required this.durationTerms,
    required this.providerImage75,
    required this.providerImage200,
  });

  factory ShippingEstimate.fromJson(Map<String, dynamic> json) {
    return ShippingEstimate(
      tdid: json['tdid'],
      phone: json['phone'],
      address1: json['address_1'],
      street2: json['street2'],
      address2: json['address_2'],
      zipCode: json['zip_code'],
      countryCode: json['country_code'],
      country: json['country'],
      provider: json['provider'],
      customerName: json['customer_name'],
      token: json['token'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      estimatedDays: json['estimated_days'],
      arrivesBy: json['arrives_by'],
      durationTerms: json['duration_terms'],
      providerImage75: json['provider_image_75'],
      providerImage200: json['provider_image_200'],
    );
  }
}
