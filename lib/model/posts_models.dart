import 'package:chatapp/view/create_post/create_post.dart';

class Post {
  final String postId;
  final String userId;
  final String title;
  final String detail;
  final String imageUrl;
  final Like like;
  final List<Comment> comments;
  Post({
    required this.comments,
    required this.detail,
    required this.title,
    required this.imageUrl,
    required this.like,
    required this.postId,
    required this.userId,
  });
}

class Comment {
  final String userName;
  final String imageUrl;
  final String commentMessage;
  Comment(
      {required this.userName,
      required this.commentMessage,
      required this.imageUrl});
}

class Like {
  final int likes;
  final List<String> usernames;
  Like({
    required this.likes,
    required this.usernames,
  });
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(likes: json['likes'], usernames: json['username']);
  }
}
