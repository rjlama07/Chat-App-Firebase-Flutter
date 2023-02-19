class AuthState {
  final bool isLoad;
  final bool isSuccess;
  final bool isError;
  final String errMessage;

  AuthState(
      {required this.errMessage,
      required this.isError,
      required this.isLoad,
      required this.isSuccess});

  AuthState copyWith(
      {bool? isLoad, bool? isSuccess, bool? isError, String? errMessage}) {
    return AuthState(
        errMessage: errMessage ?? this.errMessage,
        isError: isError ?? this.isSuccess,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess);
  }
}
