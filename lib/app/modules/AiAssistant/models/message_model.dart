class Message {
  String text;
  bool isUser; // true = User, false = AI
  DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}