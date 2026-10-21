class ChatMessage {
  final String id;
  final String text;
  final String time;
  final bool isFromDriver;

  ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isFromDriver,
  });

  static List<ChatMessage> initialMessages() {
    return [
      ChatMessage(
        id: '1',
        text: 'Halo bu, saya sudah sampai di Pasar Sukaramai ya. Mulai carikan daging sapi.',
        time: '10.11',
        isFromDriver: true,
      ),
      ChatMessage(
        id: '2',
        text: 'Sekalian, cabai merahnya juga mau yang keriting atau biasa?',
        time: '10.11',
        isFromDriver: true,
      ),
      ChatMessage(
        id: '3',
        text: 'Boleh mas, sekalian aja',
        time: '10.11',
        isFromDriver: false,
      ),
      ChatMessage(
        id: '4',
        text: 'Baik bukk',
        time: '10.11',
        isFromDriver: true,
      ),
    ];
  }
}
