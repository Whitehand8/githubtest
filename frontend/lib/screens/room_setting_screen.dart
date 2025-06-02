import 'package:flutter/material.dart';
import '../services/room_service.dart';

class RoomSettingScreen extends StatefulWidget {
  @override
  _RoomSettingScreenState createState() => _RoomSettingScreenState();
}

class _RoomSettingScreenState extends State<RoomSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? _password;
  int _max = 1;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('방 설정')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              decoration: InputDecoration(labelText: '방 이름'),
              onSaved: (v) => _name = v!.trim(),
              validator: (v) => v == null || v.isEmpty ? '방 이름을 입력하세요' : null,
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(labelText: '비밀번호 (선택)'),
              obscureText: true,
              onSaved: (v) => _password = v!.isEmpty ? null : v,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('최대 인원: $_max'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _max < 9 ? () => setState(() => _max++) : null,
                ),
              ],
            ),
            SizedBox(height: 16),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text('방 생성'),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();
                      setState(() => _loading = true);
                      try {
                        final room = await RoomService.createRoom(
                          name: _name,
                          password: _password,
                          max: _max,
                        );
                        Navigator.pushReplacementNamed(
                          context,
                          '/room',
                          arguments: room,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('방 생성 실패: $e')),
                        );
                      } finally {
                        setState(() => _loading = false);
                      }
                    },
                  ),
          ]),
        ),
      ),
    );
  }
}
