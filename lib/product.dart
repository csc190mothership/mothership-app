class Product {
  final String name;
  final String imageURL;

  Product({required this.name, required this.imageURL});

  factory Product.fromJson(Map<String, dynamic> json) {
    String imageURL = "";

    final frontImage = json['images'].firstWhere(
      (img) => img['perspective'] == 'front',
      orElse: () => null,
    );
    if (frontImage != null) {
      final largeImage = frontImage['sizes'].firstWhere(
        (size) => size['size'] == 'large',
        orElse: () => null,
      );
      imageURL = largeImage != null ? largeImage['url'] : "";
    }
    return Product(name: json['description'] ?? 'No name', imageURL: imageURL);
  }
}
