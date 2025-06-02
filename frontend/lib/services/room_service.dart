import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';

import 'token_storage.dart';

/// 검색 결과를 담는 모델
class RoomSearchResult {
  final List<Room> rooms;
  final int total;

  RoomSearchResult({
    required this.rooms,
    required this.total,
  });
}

class RoomService {
  static const _url = 'http://127.0.0.1:3000/rooms';

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

  /// 방 검색 API 호출
  static Future<RoomSearchResult> searchRooms({
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    final token = await TokenStorage.readToken();
    final uri = Uri.parse('$_url/search').replace(
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final rooms = (data['data'] as List).map((e) => Room.fromJson(e)).toList();
    return RoomSearchResult(
      rooms: rooms,
      total: data['total'],
    );
  }
}
