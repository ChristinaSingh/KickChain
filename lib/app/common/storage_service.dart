import 'package:get_storage/get_storage.dart';
import '../data/apis/api_constants/api_key_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  final _box = GetStorage();

  StorageService._internal();

  // ── Token ─────────────────────────────────────
  String? getToken() => _box.read<String>(ApiKeyConstants.token);

  Future<void> saveToken(String token) async {
    await _box.write(ApiKeyConstants.token, token);
  }

  // ── User Info ─────────────────────────────────
  String? getUserId() => _box.read<String>(ApiKeyConstants.userId);
  String? getUserName() => _box.read<String>(ApiKeyConstants.userName);
  String? getUserEmail() => _box.read<String>(ApiKeyConstants.userEmail);
  String? getUserAvatar() => _box.read<String>(ApiKeyConstants.userAvatar);

  Future<void> saveUserId(String id) async {
    await _box.write(ApiKeyConstants.userId, id);
  }

  Future<void> saveUserName(String name) async {
    await _box.write(ApiKeyConstants.userName, name);
  }

  Future<void> saveUserEmail(String email) async {
    await _box.write(ApiKeyConstants.userEmail, email);
  }

  Future<void> saveUserAvatar(String avatar) async {
    await _box.write(ApiKeyConstants.userAvatar, avatar);
  }

  Future<void> saveIsLoggedIn(bool value) async {
    await _box.write(ApiKeyConstants.isLoggedIn, value);
  }

  bool isLoggedIn() =>
      _box.read<bool>(ApiKeyConstants.isLoggedIn) ?? false;

  // ── Logout / Clear Session ────────────────────
  Future<void> clearSession() async {
    await _box.remove(ApiKeyConstants.token);
    await _box.remove(ApiKeyConstants.userId);
    await _box.remove(ApiKeyConstants.userName);
    await _box.remove(ApiKeyConstants.userEmail);
    await _box.remove(ApiKeyConstants.userAvatar);
    await _box.write(ApiKeyConstants.isLoggedIn, false);
  }

  // ── Clear All ─────────────────────────────────
  Future<void> clearAll() async {
    await _box.erase();
  }

  // ── Generic Read / Write ──────────────────────
  T? read<T>(String key) => _box.read<T>(key);

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }
}