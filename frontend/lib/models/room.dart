class Room {
  final int room_number;
  final String room_name;
  final String? room_password;
  final int room_max;

  Room({
    required this.room_number,
    required this.room_name,
    required this.room_password,
    required this.room_max,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        room_number: json['room_number'],
        room_name: json['room_name'],
        room_password: json['room_password'],
        room_max: json['room_max'],
      );
}
