import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // API Configuration
  final String _groqApiKey = "YOUR_GROQ_API_KEY_HERE";
  final String _model = "llama-3.3-70b-versatile";
  
  // State variables
  String _selectedLanguage = 'English';
  bool _isTyping = false;
  bool _isStreaming = false;
  List<Map<String, dynamic>> _currentMessages = [];
  
  // Memory storage (user context)
  Map<String, String> _userMemory = {};
  List<Map<String, dynamic>> _chatHistoryList = [];
  int _currentChatId = 0;
  bool _showHistorySidebar = false;
  
  // Voice input
  SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _speechText = '';
  
  // File upload
  String? _uploadedFileName;
  String? _uploadedFileContent;
  bool _isUploading = false;
  
  // User preferences
  double _fontSize = 14.0;
  bool _voiceInputEnabled = true;

  String get _currentHintText {
    switch (_selectedLanguage) {
      case 'Kiswahili': return 'Uliza lolote...';
      case 'Français': return 'Posez votre question...';
      case 'العربية': return 'اسأل أي شيء...';
      case 'Yorùbá': return 'Béèrè lọ́wọ́...';
      case 'Hausa': return 'Tambayi kowane abu...';
      case 'አማርኛ': return 'ማንኛውንም ነገር ይጠይቁ...';
      case 'isiZulu': return 'Buza noma yini...';
      case 'Português': return 'Pergunte qualquer coisa...';
      case 'Kinyarwanda': return 'Baza ikintu cyose...';
      default: return 'Ask anything...';
    }
  }

  final List<String> _languages = [
    'English', 'Kiswahili', 'Français', 'العربية', 
    'Yorùbá', 'Hausa', 'አማርኛ', 'isiZulu', 'Português', 'Kinyarwanda'
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadUserPreferences();
    _loadUserMemory();
    _loadChatHistoryList();
    _createNewChat();
  }

  Future<void> _initSpeech() async {
    _speechToText = SpeechToText();
    bool available = await _speechToText.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (!available) {
      setState(() => _voiceInputEnabled = false);
    }
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('font_size') ?? 14.0;
      _voiceInputEnabled = prefs.getBool('voice_enabled') ?? true;
    });
  }

  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', size);
    setState(() => _fontSize = size);
  }

  // ============================================================
  // MEMORY MANAGEMENT (Remembers user info across conversations)
  // ============================================================
  
  Future<void> _loadUserMemory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? memoryJson = prefs.getString('user_memory');
    if (memoryJson != null) {
      setState(() {
        _userMemory = Map<String, String>.from(jsonDecode(memoryJson));
      });
    }
  }

  Future<void> _saveUserMemory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_memory', jsonEncode(_userMemory));
  }

  String _buildMemoryContext() {
    if (_userMemory.isEmpty) return '';
    
    String context = "\n\n[USER CONTEXT - REMEMBER THIS]:\n";
    _userMemory.forEach((key, value) {
      context += "- User's $key: $value\n";
    });
    context += "Use this information to personalize your responses. If the user asks about something you remember, use this information.\n";
    return context;
  }

  void _extractAndStoreMemory(String userMessage, String aiResponse) {
    // Extract name patterns
    final namePatterns = [
      RegExp(r'my name is (\w+)', caseSensitive: false),
      RegExp(r"i'm (\w+)", caseSensitive: false),
      RegExp(r"i am (\w+)", caseSensitive: false),
      RegExp(r"call me (\w+)", caseSensitive: false),
      RegExp(r"name's (\w+)", caseSensitive: false),
    ];
    
    for (var pattern in namePatterns) {
      final match = pattern.firstMatch(userMessage);
      if (match != null) {
        final name = match.group(1);
        if (name != null && name.length > 1) {
          _userMemory['name'] = name;
          _saveUserMemory();
          break;
        }
      }
    }
    
    // Extract age
    final agePattern = RegExp(r'i am (\d+) years? old', caseSensitive: false);
    final ageMatch = agePattern.firstMatch(userMessage);
    if (ageMatch != null) {
      _userMemory['age'] = ageMatch.group(1)!;
      _saveUserMemory();
    }
    
    // Extract location/country
    final locationPatterns = [
      RegExp(r'i live in (\w+)', caseSensitive: false),
      RegExp(r'i am from (\w+)', caseSensitive: false),
      RegExp(r'from (\w+)', caseSensitive: false),
    ];
    
    for (var pattern in locationPatterns) {
      final match = pattern.firstMatch(userMessage);
      if (match != null) {
        final location = match.group(1);
        if (location != null && location.length > 1) {
          _userMemory['location'] = location;
          _saveUserMemory();
          break;
        }
      }
    }
    
    // Extract interests
    final interestPattern = RegExp(r'i like (\w+)', caseSensitive: false);
    final interestMatch = interestPattern.firstMatch(userMessage);
    if (interestMatch != null) {
      _userMemory['interest'] = interestMatch.group(1)!;
      _saveUserMemory();
    }
  }

  // ============================================================
  // CHAT HISTORY MANAGEMENT
  // ============================================================
  
  Future<void> _loadChatHistoryList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('chat_history_list');
    if (historyJson != null) {
      setState(() {
        _chatHistoryList = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
      });
    }
  }

  Future<void> _saveChatHistoryList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history_list', jsonEncode(_chatHistoryList));
  }

  Future<void> _saveCurrentChat() async {
    if (_currentMessages.isEmpty) return;
    
    final chatTitle = _currentMessages.isNotEmpty && _currentMessages[0]['isUser'] == true
        ? (_currentMessages[0]['text'].length > 30 
            ? _currentMessages[0]['text'].substring(0, 30) + '...'
            : _currentMessages[0]['text'])
        : 'New Chat';
    
    final existingIndex = _chatHistoryList.indexWhere((chat) => chat['id'] == _currentChatId);
    
    final chatData = {
      'id': _currentChatId,
      'title': chatTitle,
      'messages': _currentMessages,
      'timestamp': DateTime.now().toIso8601String(),
      'preview': _currentMessages.isNotEmpty 
          ? (_currentMessages.last['text'].toString().length > 40 
              ? _currentMessages.last['text'].toString().substring(0, 40) + '...'
              : _currentMessages.last['text'].toString())
          : 'Empty chat',
    };
    
    if (existingIndex != -1) {
      _chatHistoryList[existingIndex] = chatData;
    } else {
      _chatHistoryList.insert(0, chatData);
    }
    
    // Keep only last 50 chats
    if (_chatHistoryList.length > 50) {
      _chatHistoryList = _chatHistoryList.sublist(0, 50);
    }
    
    await _saveChatHistoryList();
  }

  Future<void> _createNewChat() async {
    // Save current chat before creating new one
    if (_currentMessages.isNotEmpty) {
      await _saveCurrentChat();
    }
    
    setState(() {
      _currentChatId = DateTime.now().millisecondsSinceEpoch;
      _currentMessages = [
        {
          'text': 'Hello! I am Bora AI. I remember our conversations! 🧠\n\n' +
                  (_userMemory.isNotEmpty 
                      ? 'I remember you! ' + 
                        (_userMemory.containsKey('name') ? 'Your name is ${_userMemory['name']}. ' : '') +
                        (_userMemory.containsKey('location') ? 'You are from ${_userMemory['location']}. ' : '')
                      : 'Tell me your name and I will remember it for future conversations!'),
          'isUser': false,
          'time': _getCurrentTime(),
        }
      ];
    });
    _scrollToBottom();
  }

  Future<void> _loadChat(int chatId) async {
    final chat = _chatHistoryList.firstWhere((chat) => chat['id'] == chatId);
    setState(() {
      _currentChatId = chatId;
      _currentMessages = List<Map<String, dynamic>>.from(chat['messages']);
    });
    _scrollToBottom();
  }

  Future<void> _deleteChat(int chatId) async {
    setState(() {
      _chatHistoryList.removeWhere((chat) => chat['id'] == chatId);
    });
    await _saveChatHistoryList();
    
    if (_currentChatId == chatId) {
      await _createNewChat();
    }
  }

  Future<void> _clearAllChats() async {
    setState(() {
      _chatHistoryList.clear();
    });
    await _saveChatHistoryList();
    await _createNewChat();
  }

  // ============================================================
  // API CALL WITH MEMORY CONTEXT
  // ============================================================
  
  Future<void> _callGroqAPIWithStreaming(String userPrompt) async {
    setState(() => _isTyping = true);
    
    final messageIndex = _currentMessages.length;
    setState(() {
      _currentMessages.add({
        'text': '',
        'isUser': false,
        'time': _getCurrentTime(),
        'isStreaming': true,
      });
    });
    _scrollToBottom();

    try {
      String fullPrompt = userPrompt;
      if (_uploadedFileContent != null) {
        fullPrompt = "User uploaded:\n$_uploadedFileContent\n\nUser question: $userPrompt\n\nPlease analyze the uploaded content and answer based on it.";
      }
      
      // Add memory context to the prompt
      final memoryContext = _buildMemoryContext();
      final conversationHistory = _buildConversationHistory();
      
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
      
      final requestBody = {
        "model": _model,
        "messages": [
          {
            "role": "system",
            "content": "You are Bora AI, created by Kelly Joyeux Kezakimana from Burundi. You help Africans innovate, learn, and build. Respond in $_selectedLanguage. Be helpful, friendly, and concise.$memoryContext\n\nIMPORTANT: Remember user information like names, preferences, and facts they share. Use this information in future responses.$conversationHistory"
          },
          {
            "role": "user",
            "content": fullPrompt
          }
        ],
        "temperature": 0.7,
        "stream": true,
        "max_tokens": 1000,
      };
      
      final request = http.Request('POST', url);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_groqApiKey',
      });
      request.body = jsonEncode(requestBody);
      
      final response = await request.send();
      String fullResponse = '';
      
      if (response.statusCode == 200) {
        await for (var chunk in response.stream.transform(utf8.decoder)) {
          final lines = chunk.split('\n');
          for (var line in lines) {
            if (line.startsWith('data: ') && line != 'data: [DONE]') {
              try {
                final jsonStr = line.substring(6);
                final data = jsonDecode(jsonStr);
                final content = data['choices'][0]['delta']['content'];
                if (content != null) {
                  fullResponse += content;
                  setState(() {
                    _currentMessages[messageIndex]['text'] = fullResponse;
                  });
                  _scrollToBottom();
                  await Future.delayed(const Duration(milliseconds: 20));
                }
              } catch (e) {}
            }
          }
        }
        
        // Extract and store memory from user message and AI response
        _extractAndStoreMemory(userPrompt, fullResponse);
        
        setState(() {
          _currentMessages[messageIndex]['isStreaming'] = false;
          _isTyping = false;
        });
        await _saveCurrentChat();
        _clearUploadedFile();
        
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
      
    } catch (e) {
      setState(() {
        _currentMessages[messageIndex]['text'] = 'Sorry, I encountered an issue. Please try again.';
        _currentMessages[messageIndex]['isStreaming'] = false;
        _isTyping = false;
      });
    }
  }

  String _buildConversationHistory() {
    if (_currentMessages.length <= 1) return '';
    
    String history = "\n\n[RECENT CONVERSATION HISTORY]:\n";
    // Include last 5 exchanges for context
    final startIndex = _currentMessages.length > 10 ? _currentMessages.length - 10 : 0;
    for (int i = startIndex; i < _currentMessages.length; i++) {
      final msg = _currentMessages[i];
      if (msg['isUser'] == true) {
        history += "User: ${msg['text']}\n";
      } else if (msg['isUser'] == false && msg['text'].isNotEmpty && !msg.containsKey('isStreaming')) {
        history += "Bora: ${msg['text']}\n";
      }
    }
    return history;
  }

  // ============================================================
  // UI METHODS
  // ============================================================
  
  Future<void> _loadPersistedMessages() async {
    // This is now handled by _loadChatHistoryList and _createNewChat
  }

  Future<void> _saveMessagesToCache() async {
    await _saveCurrentChat();
  }

  Future<void> _clearChatHistory() async {
    await _clearAllChats();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _startListening() async {
    if (!_voiceInputEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice input not available on this device')),
      );
      return;
    }
    
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _speechText = result.recognizedWords;
            _messageController.text = _speechText;
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: _selectedLanguage == 'Kiswahili' ? 'sw_KE' : 
                  _selectedLanguage == 'Français' ? 'fr_FR' : 'en_US',
      );
    }
  }

  Future<void> _stopListening() async {
    setState(() => _isListening = false);
    await _speechToText.stop();
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _uploadedFileName = image.name;
        _isUploading = true;
      });
      
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      setState(() {
        _uploadedFileContent = "Image uploaded: ${image.name}\n[Image data ready for analysis]";
        _isUploading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded: ${image.name}')),
      );
    }
  }

  Future<void> _uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'doc', 'docx', 'md'],
    );
    
    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
        _isUploading = true;
      });
      
      final bytes = result.files.single.bytes;
      final content = utf8.decode(bytes ?? []);
      
      String displayContent = content;
      if (content.length > 1000) {
        displayContent = content.substring(0, 1000) + '\n...[content truncated]';
      }
      
      setState(() {
        _uploadedFileContent = "Document: ${result.files.single.name}\n\nContent:\n$displayContent";
        _isUploading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document uploaded: ${result.files.single.name}')),
      );
    }
  }

  void _clearUploadedFile() {
    setState(() {
      _uploadedFileName = null;
      _uploadedFileContent = null;
    });
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _uploadedFileContent == null) return;

    _messageController.clear();
    
    setState(() {
      _currentMessages.add({
        'text': text,
        'isUser': true,
        'time': _getCurrentTime(),
      });
    });
    
    _scrollToBottom();
    _callGroqAPIWithStreaming(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _copyToClipboard(String rawText) {
    Clipboard.setData(ClipboardData(text: rawText)).then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied!'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.text_fields, color: Color(0xFF10B981)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Font Size: ${_fontSize.round()}', style: const TextStyle(color: Colors.white)),
                      Slider(
                        value: _fontSize,
                        min: 10,
                        max: 20,
                        divisions: 10,
                        activeColor: const Color(0xFF10B981),
                        onChanged: (value) {
                          _saveFontSize(value);
                          Navigator.pop(context);
                          _showSettingsDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.mic, color: Color(0xFF10B981)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Voice Input', style: TextStyle(color: Colors.white)),
                ),
                Switch(
                  value: _voiceInputEnabled,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('voice_enabled', value);
                    setState(() => _voiceInputEnabled = value);
                    if (value) _initSpeech();
                  },
                  activeColor: const Color(0xFF10B981),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            Text('Memory: ${_userMemory.isNotEmpty ? "Active" : "Empty"}', 
                 style: TextStyle(color: _userMemory.isNotEmpty ? Color(0xFF10B981) : Colors.grey)),
            if (_userMemory.isNotEmpty)
              Column(
                children: _userMemory.entries.map((entry) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('${entry.key}: ${entry.value}', 
                         style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  )
                ).toList(),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _userMemory.clear();
                _saveUserMemory();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Memory cleared!'), backgroundColor: Color(0xFF10B981)),
              );
            },
            child: const Text('Clear Memory', style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF10B981))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Chat History Sidebar (Left)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _showHistorySidebar ? 280 : 0,
          child: _showHistorySidebar ? _buildChatHistorySidebar() : const SizedBox.shrink(),
        ),
        
        // Main Chat Area
        Expanded(
          child: Container(
            color: const Color(0xFF0B0F19),
            child: Column(
              children: [
                // Top Bar with History Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFF1E293B),
                  child: Row(
                    children: [
                      // History Toggle Button
                      IconButton(
                        icon: Icon(
                          _showHistorySidebar ? LucideIcons.panelLeftClose : LucideIcons.panelLeftOpen,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _showHistorySidebar = !_showHistorySidebar;
                          });
                        },
                        tooltip: 'Chat History',
                      ),
                      
                      // New Chat Button
                      IconButton(
                        icon: const Icon(LucideIcons.plus, color: Color(0xFF10B981), size: 20),
                        onPressed: _createNewChat,
                        tooltip: 'New Chat',
                      ),
                      
                      const Spacer(),
                      
                      // Settings Button
                      IconButton(
                        icon: const Icon(LucideIcons.settings, color: Colors.white, size: 20),
                        onPressed: _showSettingsDialog,
                        tooltip: 'Settings',
                      ),
                      
                      // Voice Button
                      IconButton(
                        icon: Icon(_isListening ? Icons.stop : LucideIcons.mic, 
                                 color: _isListening ? Colors.red : Colors.white, size: 20),
                        onPressed: _voiceInputEnabled ? (_isListening ? _stopListening : _startListening) : null,
                        tooltip: 'Voice Input',
                      ),
                      
                      // File Upload Popup
                      PopupMenuButton<String>(
                        icon: const Icon(LucideIcons.paperclip, color: Colors.white, size: 20),
                        onSelected: (value) {
                          if (value == 'image') _uploadImage();
                          if (value == 'document') _uploadDocument();
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'image', child: Row(
                            children: [Icon(Icons.image), SizedBox(width: 8), Text('Upload Image')],
                          )),
                          const PopupMenuItem(value: 'document', child: Row(
                            children: [Icon(Icons.description), SizedBox(width: 8), Text('Upload Document')],
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Uploaded File Indicator
                if (_uploadedFileName != null)
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.file, color: Color(0xFF10B981), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _uploadedFileName!,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x, color: Colors.grey, size: 14),
                          onPressed: _clearUploadedFile,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                
                // Chat Messages Area
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _currentMessages.length,
                    itemBuilder: (context, index) {
                      final msg = _currentMessages[index];
                      final isUser = msg['isUser'] as bool;
                      final text = msg['text'] as String;
                      final isStreaming = msg['isStreaming'] as bool? ?? false;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser ? const Color(0xFF10B981).withOpacity(0.15) : const Color(0xFF1E293B),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(isUser ? 12 : 0),
                                bottomRight: Radius.circular(isUser ? 0 : 12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (text.isEmpty && isStreaming)
                                  const Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Bora is thinking...',
                                        style: TextStyle(color: Colors.grey, fontSize: 13),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    text,
                                    style: TextStyle(color: Colors.white, fontSize: _fontSize, height: 1.4),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (text.isNotEmpty)
                                      Text(
                                        msg['time'],
                                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                                      ),
                                    if (!isUser && text.isNotEmpty) ...[
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () => _copyToClipboard(text),
                                        child: Row(
                                          children: [
                                            Icon(LucideIcons.copy, size: 11, color: Colors.grey[400]),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Copy',
                                              style: TextStyle(color: Colors.grey[400], fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Voice Listening Indicator
                if (_isListening)
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mic, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'Listening...',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _stopListening,
                          child: const Icon(Icons.stop, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                
                // Input Area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              onSubmitted: (_) => _handleSendMessage(),
                              style: TextStyle(color: Colors.white, fontSize: _fontSize),
                              decoration: InputDecoration(
                                hintText: _currentHintText,
                                hintStyle: TextStyle(color: Colors.grey[500], fontSize: _fontSize),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                              onPressed: _handleSendMessage,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFF1E293B), height: 1),
                      const SizedBox(height: 12),
                      
                      // Language Chips
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _languages.length,
                          itemBuilder: (context, index) {
                            final lang = _languages[index];
                            final isSelected = lang == _selectedLanguage;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _selectedLanguage = lang);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF10B981).withOpacity(0.15) : const Color(0xFF0B0F19),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFF334155),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    lang,
                                    style: TextStyle(
                                      color: isSelected ? const Color(0xFF10B981) : Colors.grey[400],
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Chat History Sidebar Widget
  Widget _buildChatHistorySidebar() {
    return Container(
      color: const Color(0xFF111827),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                const Text(
                  'Chat History',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 18),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF111827),
                        title: const Text('Clear All Chats?', style: TextStyle(color: Colors.white)),
                        content: const Text('This will delete all your chat history. This action cannot be undone.',
                            style: TextStyle(color: Colors.grey)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                          ),
                          TextButton(
                            onPressed: () {
                              _clearAllChats();
                              Navigator.pop(context);
                            },
                            child: const Text('Delete All', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Clear all chats',
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, height: 0),
          Expanded(
            child: _chatHistoryList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.messageSquare, color: Colors.grey, size: 40),
                        SizedBox(height: 12),
                        Text('No chat history', style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text('Start a new conversation!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _chatHistoryList.length,
                    itemBuilder: (context, index) {
                      final chat = _chatHistoryList[index];
                      final isSelected = chat['id'] == _currentChatId;
                      return Dismissible(
                        key: Key(chat['id'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteChat(chat['id']),
                        child: ListTile(
                          leading: Icon(LucideIcons.messageSquare, 
                              color: isSelected ? const Color(0xFF10B981) : Colors.grey, size: 18),
                          title: Text(
                            chat['title'],
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF10B981) : Colors.white,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            chat['preview'],
                            style: TextStyle(color: Colors.grey[500], fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          selected: isSelected,
                          selectedTileColor: const Color(0xFF10B981).withOpacity(0.1),
                          onTap: () => _loadChat(chat['id']),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}