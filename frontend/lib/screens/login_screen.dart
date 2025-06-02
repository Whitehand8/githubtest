// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _id = '', _password = '';
  bool _loading = false;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이디 입력
              TextFormField(
                decoration: InputDecoration(labelText: 'ID'),
                onSaved: (v) => _id = v ?? '',
                validator: (v) => v == null || v.isEmpty ? '아이디를 입력하세요' : null,
              ),
              // 비밀번호 입력
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _password = v ?? '',
                validator: (v) => v == null || v.isEmpty ? '비밀번호를 입력하세요' : null,
              ),
              SizedBox(height: 16),
              // 로그인 버튼
              ElevatedButton(
                child: Text('Login'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  final ok = await AuthService.login(
                    id: _id,
                    password: _password,
                  );

                  if (ok) {
                    Navigator.pushReplacementNamed(context, '/');
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('로그인 실패')));
                  }
                },
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pushNamed(ctx, '/signup'),
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
