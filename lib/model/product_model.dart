class Products {
  Products({
    required this.name,
    required this.image,
  });

  String name;
  String image;

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
