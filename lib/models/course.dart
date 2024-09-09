class Course {
  final int id;
  final String title;
  final String author;
  final String imageUrl;
  final String status;

  Course({required this.id, required this.title, required this.author, required this.imageUrl, required this.status});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      imageUrl: json['image_url'],
      status: json['status'],
    );
  }
}
