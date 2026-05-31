import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ─── CONFIG ───────────────────────────────────────────────────────────────────
const String _kBaseUrl = 'http://10.106.47.101:5000';

// ─── MODEL ────────────────────────────────────────────────────────────────────
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final bool isError;
  final String? language; // 'english' | 'sinhala' | 'tamil'
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.isError = false,
    this.language,
  });
}

// ─── SERVICE ──────────────────────────────────────────────────────────────────
class ChatbotService {
  static Future<Map<String, String>> sendMessage(
      String message, String lang) async {
    try {
      final uri = Uri.parse('$_kBaseUrl/chat');
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': message, 'lang': lang}),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'reply': (data['reply'] as String?) ?? 'No response.',
          'language': (data['language'] as String?) ?? 'english',
        };
      } else {
        return {
          'reply': '⚠️ Server error ${res.statusCode}.',
          'language': 'english'
        };
      }
    } on Exception catch (e) {
      return {
        'reply':
            '📡 Could not reach AgroBot server.\n\nMake sure your ML server is running at $_kBaseUrl\n\nError: $e',
        'language': 'english',
      };
    }
  }
}

// ─── SCREEN ───────────────────────────────────────────────────────────────────
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  // State
  bool _isTyping = false;
  bool _isListening = false;
  bool _isSpeaking = false;
// updates based on detected language

  // Voice
  final SpeechToText _stt = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _sttAvailable = false;

  // Language → STT locale mapping
  final Map<String, String> _sttLocales = {
    'english': 'en-US',
    'sinhala': 'si-LK',
    'tamil': 'ta-LK',
  };

  // Language → TTS locale mapping
  final Map<String, String> _ttsLocales = {
    'english': 'en-US',
    'sinhala': 'si-LK',
    'tamil': 'ta-IN',
  };

  // Language → display label
  final Map<String, String> _langLabels = {
    'english': '🇬🇧 EN',
    'sinhala': '🇱🇰 SI',
    'tamil': '🇮🇳 TA',
  };

  // Currently selected input language (for mic)
  String _selectedLang = 'english';

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello Farmer! 👋 I'm AgroBot.\n\n"
          "Tap the 🎤 mic button and speak in:\n"
          "• English\n• සිංහල (Sinhala)\n• தமிழ் (Tamil)\n\n"
          "I'll reply in your language!",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      language: 'english',
    ),
  ];

  final List<String> _quickReplies = [
    '🌾 Paddy disease?',
    '🌽 Corn tips',
    '💧 Water schedule',
    '📦 Prices',
    'වී රෝග?',
    'நெல் நோய்?',
  ];

  @override
  void initState() {
    super.initState();
    _initStt();
    _initTts();
  }

  // ── Init STT ─────────────────────────────────────────────────────────────────
  Future<void> _initStt() async {
    _sttAvailable = await _stt.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (error) {
        if (mounted) setState(() => _isListening = false);
        _showSnack('Mic error: ${error.errorMsg}');
      },
    );
    if (mounted) setState(() {});
  }

  // ── Init TTS ─────────────────────────────────────────────────────────────────
  Future<void> _initTts() async {
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    _tts.setStartHandler(() => setState(() => _isSpeaking = true));
    _tts.setCompletionHandler(() => setState(() => _isSpeaking = false));
    _tts.setErrorHandler((_) => setState(() => _isSpeaking = false));
  }

  // ── Speak a reply ─────────────────────────────────────────────────────────────
  Future<void> _speak(String text, String language) async {
    await _tts.stop();
    final locale = _ttsLocales[language] ?? 'en-US';
    await _tts.setLanguage(locale);
    await _tts.speak(text);
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    setState(() => _isSpeaking = false);
  }

  // ── Start listening ───────────────────────────────────────────────────────────
  Future<void> _startListening() async {
    if (!_sttAvailable) {
      _showSnack('Microphone not available on this device.');
      return;
    }
    if (_isListening) {
      await _stt.stop();
      setState(() => _isListening = false);
      return;
    }

    final locale = _sttLocales[_selectedLang] ?? 'en-US';

    setState(() => _isListening = true);
    await _stt.listen(
      localeId: locale,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          _controller.text = result.recognizedWords;
          setState(() => _isListening = false);
          _sendMessage(result.recognizedWords);
        }
      },
    );
  }

  // ── Send message ──────────────────────────────────────────────────────────────
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        time: DateTime.now(),
        language: _selectedLang,
      ));
      _isTyping = true;
    });
    _scrollToBottom();

    final result = await ChatbotService.sendMessage(text, _selectedLang);
    final reply = result['reply']!;
    final lang = result['language']!;

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: reply,
        isUser: false,
        time: DateTime.now(),
        language: lang,
        isError: reply.startsWith('⚠️') || reply.startsWith('📡'),
      ));
    });
    _scrollToBottom();

    // Auto-speak the reply
    if (!reply.startsWith('⚠️') && !reply.startsWith('📡')) {
      await _speak(reply, lang);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF1B6B3A)),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _languageSelector(),
          Expanded(child: _messageList()),
          if (_messages.length == 1) _quickRepliesRow(),
          _inputBar(),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF1B6B3A),
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AgroBot',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              Row(children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFF66BB6A), shape: BoxShape.circle)),
                const SizedBox(width: 4),
                const Text('ML + Voice',
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
              ]),
            ],
          ),
        ],
      ),
      actions: [
        // Stop speaking button (visible while TTS is active)
        if (_isSpeaking)
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
            tooltip: 'Stop speaking',
            onPressed: _stopSpeaking,
          ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: () => _showSnack('ML Server: $_kBaseUrl'),
        ),
      ],
    );
  }

  // ── Language selector ──────────────────────────────────────────────────────────
  Widget _languageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF1B6B3A).withOpacity(0.08),
      child: Row(
        children: [
          const Icon(Icons.mic_rounded, size: 14, color: Color(0xFF1B6B3A)),
          const SizedBox(width: 6),
          const Text('Speak in:',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1B6B3A),
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          ..._sttLocales.keys.map((lang) {
            final selected = _selectedLang == lang;
            return GestureDetector(
              onTap: () => setState(() => _selectedLang = lang),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF1B6B3A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1B6B3A)),
                ),
                child: Text(
                  _langLabels[lang]!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : const Color(0xFF1B6B3A),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Message list ──────────────────────────────────────────────────────────────
  Widget _messageList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) return _typingIndicator();
        return _buildMessage(_messages[index]);
      },
    );
  }

  // ── Quick replies ─────────────────────────────────────────────────────────────
  Widget _quickRepliesRow() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _quickReplies.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => _sendMessage(_quickReplies[i]),
          child: Container(
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1B6B3A)),
            ),
            child: Text(_quickReplies[i],
                style: const TextStyle(
                    color: Color(0xFF1B6B3A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  // ── Input bar ─────────────────────────────────────────────────────────────────
  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          // ── Mic button ──────────────────────────────────────────────────────
          GestureDetector(
            onTap: _startListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _isListening
                    ? Colors.red
                    : const Color(0xFF1B6B3A).withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isListening ? Colors.red : const Color(0xFF1B6B3A),
                  width: 1.5,
                ),
              ),
              child: Icon(
                _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                color: _isListening ? Colors.white : const Color(0xFF1B6B3A),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // ── Listening indicator OR text field ───────────────────────────────
          Expanded(
            child: _isListening
                ? _listeningIndicator()
                : TextField(
                    controller: _controller,
                    enabled: !_isTyping,
                    decoration: InputDecoration(
                      hintText: _isTyping
                          ? 'AgroBot is thinking...'
                          : 'Type or tap 🎤 to speak...',
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: _isTyping ? null : _sendMessage,
                  ),
          ),
          const SizedBox(width: 8),

          // ── Send button ─────────────────────────────────────────────────────
          GestureDetector(
            onTap: _isTyping ? null : () => _sendMessage(_controller.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _isTyping ? Colors.grey[300] : const Color(0xFF1B6B3A),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded,
                  color: _isTyping ? Colors.grey : Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ── Listening animation widget ────────────────────────────────────────────────
  Widget _listeningIndicator() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.graphic_eq_rounded, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Listening in ${_langLabels[_selectedLang]}...',
              style: const TextStyle(
                  color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          // Animated dots
          _dot(0, Colors.red),
          const SizedBox(width: 3),
          _dot(150, Colors.red),
          const SizedBox(width: 3),
          _dot(300, Colors.red),
        ],
      ),
    );
  }

  // ── Message bubble ────────────────────────────────────────────────────────────
  Widget _buildMessage(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!msg.isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        msg.isError ? Colors.orange : const Color(0xFF1B6B3A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    msg.isError ? Icons.warning_amber_rounded : Icons.smart_toy,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg.isUser
                        ? const Color(0xFF1B6B3A)
                        : msg.isError
                            ? Colors.orange.shade50
                            : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                      bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                    ),
                    border: msg.isError
                        ? Border.all(color: Colors.orange.shade200)
                        : null,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser
                          ? Colors.white
                          : msg.isError
                              ? Colors.orange.shade800
                              : const Color(0xFF333333),
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              if (msg.isUser) const SizedBox(width: 8),
            ],
          ),

          // ── Replay / language badge row (bot messages only) ─────────────────
          if (!msg.isUser && !msg.isError) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Row(
                children: [
                  // Language badge
                  if (msg.language != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B6B3A).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _langLabels[msg.language] ?? '',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF1B6B3A),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Replay button
                  GestureDetector(
                    onTap: () => _speak(msg.text, msg.language ?? 'english'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFF1B6B3A).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up_rounded,
                              size: 12, color: Color(0xFF1B6B3A)),
                          SizedBox(width: 3),
                          Text('Replay',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF1B6B3A),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Typing indicator ──────────────────────────────────────────────────────────
  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
                color: Color(0xFF1B6B3A), shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              _dot(0, const Color(0xFF1B6B3A)),
              const SizedBox(width: 4),
              _dot(200, const Color(0xFF1B6B3A)),
              const SizedBox(width: 4),
              _dot(400, const Color(0xFF1B6B3A)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _dot(int delayMs, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delayMs),
      curve: Curves.easeInOut,
      builder: (_, value, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Color.lerp(Colors.grey[300], color, value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    _stt.stop();
    _tts.stop();
    super.dispose();
  }
}
