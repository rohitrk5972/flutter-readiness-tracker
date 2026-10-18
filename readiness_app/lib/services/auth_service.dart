import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local auth: passwords are never stored in plain text.
/// Each user gets a random salt; we store SHA-256(salt + password).
class AuthService extends ChangeNotifier {
  late SharedPreferences _prefs;
  String? currentUser;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    currentUser = _prefs.getString('session_user');
  }

  Map<String, dynamic> get _users =>
      jsonDecode(_prefs.getString('users') ?? '{}') as Map<String, dynamic>;

  String _salt() {
    final r = Random.secure();
    return base64UrlEncode(List<int>.generate(16, (_) => r.nextInt(256)));
  }

  String _hash(String salt, String pw) =>
      sha256.convert(utf8.encode('$salt$pw')).toString();

  String? validate(String email, String pw) {
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!ok) return 'Enter a valid email';
    if (pw.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  Future<String?> register(String email, String pw) async {
    email = email.trim().toLowerCase();
    final err = validate(email, pw);
    if (err != null) return err;
    final users = _users;
    if (users.containsKey(email)) return 'Account already exists';
    final salt = _salt();
    users[email] = {'salt': salt, 'hash': _hash(salt, pw)};
    await _prefs.setString('users', jsonEncode(users));
    return login(email, pw);
  }

  Future<String?> login(String email, String pw) async {
    email = email.trim().toLowerCase();
    final u = _users[email];
    if (u == null || _hash(u['salt'], pw) != u['hash']) {
      return 'Invalid email or password';
    }
    currentUser = email;
    await _prefs.setString('session_user', email);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    currentUser = null;
    await _prefs.remove('session_user');
    notifyListeners();
  }
}
