class Category {
  int categoryId;
  String categoryName;
  String categoryDesc;
  int parent;
  Image? image;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDesc,
    required this.parent,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['id'],
      categoryName: json['name'],
      categoryDesc: json['description'],
      parent: json['parent'],
      image: json['image'] != null ? Image.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = categoryId;
    data['name'] = categoryName;
    data['description'] = categoryDesc;
    data['parent'] = parent;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Image {
  String url;

  Image({required this.url});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['src'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['src'] = url;
    return data;
  }
}
