class MessageModel {
  final String sender;
  final String time;
  final String text;
  final bool isMe;
  final String avatar;

  MessageModel({
    required this.sender,
    required this.time,
    required this.text,
    required this.isMe,
    required this.avatar,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'] ?? '',
      time: json['time'] ?? '',
      text: json['text'] ?? '',
      isMe: json['isMe'] ?? false,
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'time': time,
      'text': text,
      'isMe': isMe,
      'avatar': avatar,
    };
  }
}
