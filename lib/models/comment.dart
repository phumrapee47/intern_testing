class Comments {
  int postId;
  int id;
  String name;
  String email;
  String body;

  Comments({required this.postId, required this.id, required this.name, required this.email, required this.body});

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }

  @override
  String toString() {
    return 'Comments{postId: $postId, id: $id, name: $name, email: $email, body: $body}';
  }
}
