class Address {
  String address1;
  String address2;
  String city;
  String stateCode;
  String countryCode;
  String zipCode;

  Address({
    required this.address1,
    required this.address2,
    required this.city,
    required this.stateCode,
    required this.countryCode,
    required this.zipCode,
  });

  // Convert Address to Map for SharedPreferences saving
  Map<String, String> toMap() {
    return {
       "address_id": "2442",
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'state_code': stateCode,
      'country_code': countryCode,
      'zip_code': zipCode,
    };
  }

  // Convert Map to Address (used when loading from SharedPreferences)
  static Address fromMap(Map<String, String> map) {
    return Address(
      address1: map['address_1'] ?? '',
      address2: map['address_2'] ?? '',
      city: map['city'] ?? '',
      stateCode: map['state_code'] ?? '',
      countryCode: map['country_code'] ?? '',
      zipCode: map['zip_code'] ?? '',
    );
  }
}
