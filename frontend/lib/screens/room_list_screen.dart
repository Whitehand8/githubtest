import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../models/room.dart';

class RoomListScreen extends StatefulWidget {
  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final _searchController = TextEditingController();
  final _scrollCtrl = ScrollController();
  List<Room> _rooms = [];
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent &&
          _hasMore &&
          !_loading) {
        _fetchRooms();
      }
    });
  }

  Future<void> _fetchRooms({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _rooms.clear();
      _hasMore = true;
    }
    setState(() => _loading = true);
    final result = await RoomService.searchRooms(
      query: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      page: _page,
      limit: _limit,
    );
    setState(() {
      _loading = false;
      _rooms.addAll(result.rooms);
      _hasMore = _rooms.length < result.total;
      if (_hasMore) _page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('방 찾기')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '방 이름 검색...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _fetchRooms(reset: true),
                ),
              ),
              onSubmitted: (_) => _fetchRooms(reset: true),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                controller: _scrollCtrl,
                itemCount: _rooms.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i >= _rooms.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final room = _rooms[i];
                  return ListTile(
                    title: Text('${room.room_name} (#${room.room_number})'),
                    subtitle: Text(
                        '참가: ${room.currentMembers}/${room.room_max}명 • 방장: ${room.ownerId}'),
                    onTap: () => Navigator.pushNamed(
                      ctx,
                      '/room',
                      arguments: room,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
