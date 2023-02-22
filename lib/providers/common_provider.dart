import 'package:chatapp/resources/firebase_instance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final commonProvider =
    StateNotifierProvider<CommonProvider, bool>((ref) => CommonProvider(true));

class CommonProvider extends StateNotifier<bool> {
  CommonProvider(super.state);
  void togle() {
    state = !state;
  }
}

final statusProvider =
    StreamProvider((ref) => FirebaseInstances.firebaseAuth.authStateChanges());
final autoValid =
    StateNotifierProvider.autoDispose<AutoValidMode, AutovalidateMode>(
        (ref) => AutoValidMode(AutovalidateMode.disabled));

class AutoValidMode extends StateNotifier<AutovalidateMode> {
  AutoValidMode(super.state);
  void togle() {
    state = AutovalidateMode.onUserInteraction;
  }
}

final imageProvider =
    StateNotifierProvider<ImageProvider, XFile?>((ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?> {
  ImageProvider(super.state);

  void imagePick(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    if (isCamera) {
      state = await picker.pickImage(source: ImageSource.camera);
    } else {
      state = await picker.pickImage(source: ImageSource.gallery);
    }
  }
}

class ShowPassword extends StateNotifier<bool> {
  ShowPassword(super.state);

  void viewPassword() {
    state = !state;
  }
}

final showPassword =
    StateNotifierProvider<ShowPassword, bool>((ref) => ShowPassword(false));
