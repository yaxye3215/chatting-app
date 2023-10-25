class Message {
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  // Factory method to create a Message object from a map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] as String,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      timestamp: (map['timestamp'] as DateTime),
    );
  }

  // Method to convert the Message object to a map
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp,
    };
  }
}
