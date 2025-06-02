import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final room = ModalRoute.of(context)!.settings.arguments as Room;
    return Scaffold(
      appBar: AppBar(title: Text('방 #${room.room_number}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('방 이름: ${room.room_name}'),
          Text('최대 인원: ${room.room_max}명'),
          if (room.room_password != null) Text('비밀번호 설정됨'),
        ]),
      ),
    );
  }
}
