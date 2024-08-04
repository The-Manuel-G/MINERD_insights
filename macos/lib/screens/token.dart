class TokenApi {
  static final TokenApi _token = TokenApi._internal();
  String? token;

  factory TokenApi() {
    return _token;
  }

  TokenApi._internal();
}
