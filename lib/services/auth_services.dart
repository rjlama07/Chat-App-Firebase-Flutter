import 'dart:io';

import 'package:chatapp/resources/firebase_instance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final userstream = StreamProvider((ref) => FirebaseInstances.fireChat.users());

class AuthService {
  static CollectionReference userData =
      FirebaseInstances.firestore.collection("users");

  static Stream<types.User> getUserById(String uid) {
    return userData.doc(uid).snapshots().map((event) {
      final json = event.data() as Map<String, dynamic>;
      return types.User(
          id: event.id,
          firstName: json['firstName'],
          imageUrl: json['imageUrl'],
          metadata: {
            'email': json['metadata']['email'],
            'token': json['metadata']['token']
          });
    });
  }

  static Future<Either<String, bool>> userSignUp({
    required String username,
    required String password,
    required String email,
    required XFile image,
  }) async {
    try {
      final token = await FirebaseInstances.firebaseMessaging.getToken();
      final ref = FirebaseInstances.firebaseStorage
          .ref()
          .child('userImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      final credential = await FirebaseInstances.firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseInstances.fireChat.createUserInFirestore(types.User(
          id: credential.user!.uid,
          imageUrl: url,
          firstName: username,
          lastName: " ",
          metadata: {
            'email': email,
            'token': token,
          }));

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

final userStream = StreamProvider.autoDispose
    .family((ref, String userId) => AuthService.getUserById(userId));
