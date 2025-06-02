import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

/// AuthService: 백엔드 API(auth/signup)와 통신하는 helper 클래스입니다.
class AuthService {
  // 백엔드 서버의 회원가입 엔드포인트 (포트, 도메인에 맞게 조정)
  static const _baseUrl = 'http://127.0.0.1:3000/auth';

  /// 회원가입 API 호출
  /// - 성공 시 true, 실패 시 false 반환
  static Future<bool> signUp({
    required String id,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
  }) async {
    // User 객체로 묶어서 JSON 변환
    final user = User(
      id: id,
      password: password,
      confirmPassword: confirmPassword,
      email: email,
      phone: phone,
    );

    // 디버깅 용 출력
    final uri = Uri.parse('$_baseUrl/signup');
    print('[AuthService] signUp 호출 URL: $uri');
    print('[AuthService] 보낼 Body: ${jsonEncode(user.toJson())}');
    // 실제 API 호출
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    // 4) 디버깅용 로그 출력: 응답 상태 코드와 바디
    print('[AuthService] Response Code: ${response.statusCode}');
    print('[AuthService] Response Body: ${response.body}');

    // 201 Created 가 오면 성공
    return response.statusCode == 201;
  }

  /// 소셜 로그인 (예: google, naver, apple)
  /// - provider 에 맞춰 백엔드에서 처리된 토큰을 받아옵니다.
  static Future<String?> socialLogin(String provider) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/oauth/$provider'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'] as String?;
    }
    return null;
  }

  // lib/services/auth_service.dart
  /// 로그인 API 호출
  // - 성공 시 true, 실패 시 false 반환
  static Future<bool> login({
    required String id,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password}),
    );
    if (res.statusCode == 200) {
      // 예: 받은 JWT 토큰을 로컬에 저장하고 싶으면 여기서 처리
      // final data = jsonDecode(res.body);
      // await storage.write(key: 'jwt', value: data['token']);
      return true;
    }
    return false;
  }
}
