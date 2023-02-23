import 'dart:io';

import 'package:chatapp/model/posts_models.dart';
import 'package:chatapp/resources/firebase_instance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class PostService {
  static CollectionReference postDb =
      FirebaseInstances.firestore.collection("posts");
  // static Stream<List<Post>> getPost() {
  //   return postDb.snapshots().map((event) => null);
  // }

  // static List<Post> getPostData(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((e) {
  //     final json = e.data as Map<String, dynamic>;
  //     return Post(
  //         comments: json['comments'],
  //         detail: json['detail'],
  //         title: json['title'],
  //         imageUrl: json['imageUrl'],
  //         like: Like.fromJson(json['likes']),
  //         postId: json['postId'],
  //         userId: json['userID']);
  //   });
  // }

  static Future<Either<String, bool>> addPost({
    required String title,
    required String detail,
    required String userID,
    required XFile image,
  }) async {
    try {
      final ref = FirebaseInstances.firebaseStorage
          .ref()
          .child('postImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      await postDb.add({
        "userId": userID,
        "title": title,
        "detail": detail,
        "imageUrl": url,
        "like": {'likes': 0, 'usernames': [], 'comments': []}
      });
      return right(true);
    } on FirebaseAuthException catch (err) {
      return Left(err.message.toString());
    }
  }

  static Future<Either<String, bool>> userLogin(
      String email, String password) async {
    try {
      await FirebaseInstances.firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return left(e.message.toString());
    }
  }

  static Future<Either<String, bool>> userLogOut() async {
    try {
      FirebaseInstances.firebaseAuth.signOut();
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return left(e.message.toString());
    }
  }
}
