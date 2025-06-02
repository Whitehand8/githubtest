import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// SignupScreen: 아이디/비밀번호/비밀번호 확인/이메일/전화번호 입력 폼을 제공합니다.
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // 폼 필드에 입력된 값을 저장할 변수
  String _id = '';
  String _password = '';
  String _confirmPassword = '';
  String _email = '';
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')), // 상단바 제목
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // 폼 유효성 검사를 위해 GlobalKey 연결
          child: ListView(
            children: [
              // 1) 아이디 입력
              TextFormField(
                decoration: InputDecoration(labelText: 'ID'),
                onSaved: (v) => _id = v?.trim() ?? '',
                validator: (v) => v == null || v.isEmpty ? '아이디를 입력하세요' : null,
              ),
              SizedBox(height: 16),

              // 2) 비밀번호 입력
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true, // 입력 글자 가리기
                onSaved: (v) => _password = v ?? '',
                validator: (v) {
                  if (v == null || v.isEmpty) return '비밀번호를 입력하세요';
                  if (v.length < 8) return '8자 이상 입력하세요';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // 3) 비밀번호 확인
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onSaved: (v) => _confirmPassword = v ?? '',
                validator: (v) {
                  if (v == null || v.isEmpty) return '비밀번호 확인을 입력하세요';
                  if (v != _password && _password.isNotEmpty)
                    return '비밀번호가 일치하지 않습니다';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // 4) 이메일 입력
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (v) => _email = v?.trim() ?? '',
                validator: (v) {
                  if (v == null || v.isEmpty) return '이메일을 입력하세요';
                  if (!v.contains('@')) return '유효한 이메일을 입력하세요';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // 5) 전화번호 입력
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone (010-1234-5678)'),
                keyboardType: TextInputType.phone,
                onSaved: (v) => _phone = v?.trim() ?? '',
                validator: (v) {
                  final pattern = RegExp(r'^\d{2,3}-\d{3,4}-\d{4}$');
                  if (v == null || v.isEmpty) return '전화번호를 입력하세요';
                  if (!pattern.hasMatch(v)) return '형식에 맞게 입력하세요';
                  return null;
                },
              ),
              SizedBox(height: 24),

              // 회원가입 버튼
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () async {
                  // 1) 폼 검증
                  if (!_formKey.currentState!.validate()) return;
                  // 2) 폼 저장 (onSaved 호출)
                  _formKey.currentState!.save();
                  // 3) 비밀번호 일치 여부 재검사
                  if (_password != _confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('비밀번호가 일치하지 않습니다')));
                    return;
                  }
                  // 4) 실제 API 호출
                  final success = await AuthService.signUp(
                    id: _id,
                    password: _password,
                    confirmPassword: _confirmPassword,
                    email: _email,
                    phone: _phone,
                  );
                  // 5) 결과 피드백
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(success ? '가입 성공' : '가입 실패')),
                  );
                  if (success) {
                    Navigator.pop(context); // 가입 후 이전 화면으로
                  }
                },
              ),

              Divider(height: 32),

              // 소셜 로그인 버튼 샘플
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text('Google'),
                    onPressed: () async {
                      final token = await AuthService.socialLogin('google');
                      // 토큰 후처리 (로그인 상태 저장 등)
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text('Naver'),
                    onPressed: () async {
                      final token = await AuthService.socialLogin('naver');
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text('Apple'),
                    onPressed: () async {
                      final token = await AuthService.socialLogin('apple');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
