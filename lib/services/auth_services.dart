import 'package:chatapp/resources/firebase_instance.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AuthService {
  Future<Either<String, bool>> userSignUp({
    required String username,
    required String password,
    required XFile image,
  }) async {
    try {
      final token = await FirebaseInstances.firebaseMessaging.getToken();
      final ref = FirebaseInstances.firebaseStorage
          .ref()
          .child('userImage/${image.name}');
      final url = await ref.getDownloadURL();
      final credential = await FirebaseInstances.firebaseAuth
          .createUserWithEmailAndPassword(email: username, password: password);

      await FirebaseInstances.fireChat.createUserInFirestore(types.User(
          id: credential.user!.uid,
          imageUrl: url,
          firstName: username,
          lastName: " ",
          metadata: {
            'email': username,
            'token': token,
          }));
      return right(true);
    } on FirebaseAuthException catch (err) {
      return Left(err.message.toString());
    }
  }
}
