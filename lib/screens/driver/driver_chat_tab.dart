import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class DriverChatTab extends StatefulWidget {
  const DriverChatTab({super.key});

  @override
  State<DriverChatTab> createState() => _DriverChatTabState();
}

class _DriverChatTabState extends State<DriverChatTab> {
  final TextEditingController _msgController = TextEditingController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(text: 'Hi bang, saya sudah sesuai titik penjemputan', isMe: false, time: '10.09'),
    _ChatMessage(text: 'Bang dimana ya? saya sudah sesuai titik', isMe: false, time: '10.11'),
    _ChatMessage(text: 'BANGG', isMe: false, time: '10.11'),
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text.trim(), isMe: true, time: '10.12'));
    });
    _msgController.clear();
  }

  void _showOngoingCallDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _OngoingCallSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with customer info & Call button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryPurple,
                    radius: 20,
                    child: Text('MT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('M.Topik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark)),
                        Text('Penumpang Aktif • Online', style: TextStyle(fontSize: 11, color: AppColors.successGreen)),
                      ],
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      foregroundColor: AppColors.successGreen,
                    ),
                    icon: const Icon(Icons.phone),
                    onPressed: _showOngoingCallDialog,
                  ),
                ],
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: msg.isMe ? AppColors.primaryDark : const Color(0xFFEDE8FF),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(msg.isMe ? 16 : 4),
                          bottomRight: Radius.circular(msg.isMe ? 4 : 16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isMe ? Colors.white : AppColors.textDark,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            msg.time,
                            style: TextStyle(
                              fontSize: 9,
                              color: msg.isMe ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Quick reply chips (Frame 242:17477)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  _buildQuickReplyChip('Terima kasih banyak'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Segera meluncur ya mas'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Saya sudah di titik jemput'),
                ],
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan untuk driver / penumpang...',
                        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryPurple,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(_msgController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplyChip(String text) {
    return ActionChip(
      backgroundColor: const Color(0xFFF3F0FF),
      side: const BorderSide(color: AppColors.accentPastel),
      label: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
      onPressed: () => _sendMessage(text),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  _ChatMessage({required this.text, required this.isMe, required this.time});
}

// Ongoing Call Modal (Frame 242:17477 - Telpon Berlangsung)
class _OngoingCallSheet extends StatefulWidget {
  const _OngoingCallSheet();

  @override
  State<_OngoingCallSheet> createState() => _OngoingCallSheetState();
}

class _OngoingCallSheetState extends State<_OngoingCallSheet> {
  int _seconds = 83; // 01:23 as in Figma frame 242:17477
  Timer? _timer;
  bool _isMuted = false;
  bool _isSpeaker = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryPurple,
            child: Text('MT', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          const Text(
            'M.topik',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _formatTime(_seconds),
            style: const TextStyle(color: Color(0xFF00E676), fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Panggilan Suara VoIP RideOn Driver', style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 36),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 28,
                style: IconButton.styleFrom(
                  backgroundColor: _isMuted ? Colors.white : Colors.white12,
                  foregroundColor: _isMuted ? AppColors.primaryDark : Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                onPressed: () => setState(() => _isMuted = !_isMuted),
              ),
              IconButton(
                iconSize: 32,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.dangerRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(18),
                ),
                icon: const Icon(Icons.call_end),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                iconSize: 28,
                style: IconButton.styleFrom(
                  backgroundColor: _isSpeaker ? Colors.white : Colors.white12,
                  foregroundColor: _isSpeaker ? AppColors.primaryDark : Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                icon: Icon(_isSpeaker ? Icons.volume_up : Icons.volume_down),
                onPressed: () => setState(() => _isSpeaker = !_isSpeaker),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
