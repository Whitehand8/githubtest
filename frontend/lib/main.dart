// main.dart
//admin11 / dts13579$

import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
//  import 'screens/room_list_screen.dart';
import 'screens/room_setting_screen.dart';
import 'package:flutter/services.dart'; // for Exit button
import 'services/token_storage.dart'; // TokenStorage to check login
//import 'screens/room_list_screen.dart';        // Room list screen
import 'screens/room_screen.dart';

void main() => runApp(TRPGApp());

/// 최상위 앱 위젯: 라우팅 정보 설정
class TRPGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRPG Tool', // 앱 이름
      initialRoute: '/', // 시작 화면 라우트
      routes: {
        // 경로별 화면 매핑
        '/': (c) => MainScreen(),
        '/login': (c) => LoginScreen(),
        '/signup': (c) => SignupScreen(),
        '/rooms': (c) => RoomListScreen(),
        '/create': (c) => RoomSettingScreen(),
        '/room': (c) => RoomScreen(),
      },
    );
  }
}

/// MainScreen: 로그인 전/후 버튼을 구분해 표시합니다.
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await TokenStorage.readToken();
    setState(() {
      _loggedIn = token != null;
    });
  }

  void _logout() async {
    await TokenStorage.deleteToken();
    setState(() => _loggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _loggedIn
              ? [
                  ElevatedButton(
                    child: Text('Create Room'),
                    onPressed: () => Navigator.pushNamed(context, '/create'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Search Room'),
                    onPressed: () => Navigator.pushNamed(context, '/rooms'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Settings'),
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Exit'),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                ]
              : [
                  ElevatedButton(
                    child: Text('Login'),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Exit'),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                ],
        ),
      ),
    );
  }
}

/// RoomListScreen: 방 목록 화면
class RoomListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Room List')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text('Enter Room'),
              onPressed: () => Navigator.pushNamed(context, '/room'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('Back to Main'),
              onPressed: () => Navigator.pushNamed(context, '/'),
            ),
          ],
        ),
      ),
    );
  }
}
