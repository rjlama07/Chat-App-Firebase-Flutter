import 'package:chatapp/model/auth_state.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(super.state);

  Future<void> signup(
      String email, String password, String username, XFile image) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userSignUp(
        username: username, password: password, image: image, email: email);
    response.fold((l) {
      state = state.copyWith(
          isError: true, isLoad: false, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isError: false, isLoad: false, isSuccess: true, errMessage: "");
    });
  }

  Future<void> logout() async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userLogOut();
    response.fold((l) {
      state = state.copyWith(
          isError: true, isLoad: false, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isError: false, isLoad: false, isSuccess: true, errMessage: "");
    });
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userLogin(email, password);
    response.fold((l) {
      state = state.copyWith(
          isError: true, isLoad: false, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isError: false, isLoad: false, isSuccess: true, errMessage: "");
    });
  }
}

final authprovider = StateNotifierProvider<AuthProvider, AuthState>((ref) =>
    AuthProvider(AuthState(
        errMessage: '', isError: false, isLoad: false, isSuccess: false)));
