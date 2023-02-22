import 'package:chatapp/model/auth_state.dart';

import 'package:chatapp/services/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final postProvider = StateNotifierProvider<PostProvider, AuthState>(
  (ref) => PostProvider(AuthState(
      errMessage: "", isError: false, isLoad: false, isSuccess: false)),
);

class PostProvider extends StateNotifier<AuthState> {
  PostProvider(super.state);

  Future<void> addPost({
    required String title,
    required String detail,
    required String userID,
    required XFile image,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.addPost(
        title: title, detail: detail, userID: userID, image: image);
    response.fold((l) {
      state = state.copyWith(
          isError: true, isLoad: false, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isError: false, isLoad: false, isSuccess: true, errMessage: "");
    });
  }
}
