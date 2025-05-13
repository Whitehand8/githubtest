import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';
import 'token_storage.dart';

class RoomService {
  static const _url = 'http://localhost:3000/rooms';

  // 방 생성 API 호출
  static Future<Room> createRoom({
    required String name,
    String? password,
    required int max,
  }) async {
    final token = await TokenStorage.readToken();
    final res = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'room_name': name,
        'room_password': password,
        'room_max': max,
      }),
    );
    return Room.fromJson(jsonDecode(res.body));
  }
}
