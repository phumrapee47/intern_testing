class Posts {
  int userId;
  int id;
  String title;
  String body;

  Posts({required this.userId, required this.id, required this.title, required this.body});

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  

  @override
  String toString() {
    return 'Posts{userId: $userId, id: $id, title: $title, body: $body}';
  }
}