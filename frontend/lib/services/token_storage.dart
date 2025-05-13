import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Flutter Secure Storage 인스턴스
/// iOS: Keychain, Android: Keystore 를 사용해 안전하게 보관합니다.
final _secureStorage = FlutterSecureStorage();

class TokenStorage {
  static const _key = 'jwt_token';

  /// JWT 토큰 저장
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _key, value: token);
  }

  /// 저장된 JWT 토큰 읽기 (없으면 null 반환)
  static Future<String?> readToken() async {
    return await _secureStorage.read(key: _key);
  }

  /// 로그아웃 시 토큰 삭제
  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: _key);
  }
}
