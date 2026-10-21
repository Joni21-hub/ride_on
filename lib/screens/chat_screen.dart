import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../theme/colors.dart';

class ChatTab extends StatefulWidget {
  final bool isStandalone;
  const ChatTab({super.key, this.isStandalone = false});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final List<ChatMessage> _messages = ChatMessage.initialMessages();
  final TextEditingController _textController = TextEditingController();

  void _sendMessage([String? customText]) {
    final text = customText ?? _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          time: '10.12',
          isFromDriver: false,
        ),
      );
    });
    if (customText == null) _textController.clear();
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage('assets/images/avatar_peter.png'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Fikri Haykal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Panggilan Suara RideOn...',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 28),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Panggilan suara terhubung')),
                    );
                  },
                  icon: const Icon(Icons.call, color: Colors.white, size: 26),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8667FD), Color(0xFFC7BCFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  if (widget.isStandalone)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                      onPressed: () => Navigator.pop(context),
                    ),
                  // Avatar with Online Dot
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/avatar_peter.png'),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Driver Name & Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Fikri haykal (Driver)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Online (Sedang di Toko)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Call button
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      foregroundColor: AppColors.successGreen,
                    ),
                    onPressed: _showCallDialog,
                    icon: const Icon(Icons.phone, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Date pill: Hari Ini
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Hari Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Chat messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isFromDriver ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.76,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: msg.isFromDriver ? Colors.white : AppColors.primaryPurple,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(msg.isFromDriver ? 4 : 18),
                        bottomRight: Radius.circular(msg.isFromDriver ? 18 : 4),
                      ),
                      border: msg.isFromDriver
                          ? Border.all(color: AppColors.borderLight)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          msg.isFromDriver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 13,
                            color: msg.isFromDriver ? AppColors.textDark : Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: msg.isFromDriver
                                ? AppColors.primaryPurple.withOpacity(0.7)
                                : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Replies Chips (Halaman 6: Quick Reply)
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildQuickChip('Tolong cabai yang segar'),
                const SizedBox(width: 8),
                _buildQuickChip('Pilih yang belum terlalu matang'),
                const SizedBox(width: 8),
                _buildQuickChip('Terima kasih banyak'),
                const SizedBox(width: 8),
                _buildQuickChip('Segera meluncur ya mas'),
                const SizedBox(width: 8),
                _buildQuickChip('Saya sudah di depan ya'),
              ],
            ),
          ),

          // Text Composer Bar with Photo Upload (Halaman 6: Fitur Foto Barang/Nota)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryPurple, size: 22),
                  onPressed: () {
                    _sendMessage('📷 [Foto Terkirim] Foto barang belanjaan / nota alternatif');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto berhasil dikirim ke driver')),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8FC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Ketik pesan untuk driver...',
                        hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                  ),
                  onPressed: () => _sendMessage(),
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String text) {
    return ActionChip(
      onPressed: () => _sendMessage(text),
      label: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryPurple,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: const Color(0xFFF5F3FF),
      side: const BorderSide(color: AppColors.accentPastel),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
