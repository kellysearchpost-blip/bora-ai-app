import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  static const String _prefsThemeKey = 'user_theme';
  static const String _prefsLanguageKey = 'user_language';
  static const String _prefsFontSizeKey = 'user_font_size';
  static const String _prefsVoiceKey = 'user_voice_enabled';
  
  // Save user preferences
  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsThemeKey, theme);
  }
  
  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsThemeKey);
  }
  
  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsLanguageKey, language);
  }
  
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsLanguageKey);
  }
  
  Future<void> saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefsFontSizeKey, size);
  }
  
  Future<double?> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_prefsFontSizeKey);
  }
  
  Future<void> saveVoiceEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsVoiceKey, enabled);
  }
  
  Future<bool?> getVoiceEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsVoiceKey);
  }
}