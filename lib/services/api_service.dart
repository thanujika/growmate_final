import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── CONFIG ───────────────────────────────────────────────────────────────────
const String kBaseUrl = 'http://10.106.47.101:5000';

// ─── USER MODEL ───────────────────────────────────────────────────────────────
class AppUser {
  final int id;
  final String name, email, phone, cropType, region;

  AppUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.cropType,
      required this.region});

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] ?? 0,
        name: j['name'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'] ?? '',
        cropType: j['crop_type'] ?? 'Paddy',
        region: j['region'] ?? 'Central',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'crop_type': cropType,
        'region': region,
      };
}

// ─── SESSION ─────────────────────────────────────────────────────────────────
class Session {
  static String? _token;
  static AppUser? _user;

  static AppUser? get user => _user;
  static bool get loggedIn => _token != null;

  static Future<void> save(String token, AppUser user) async {
    _token = token;
    _user = user;
    final p = await SharedPreferences.getInstance();
    await p.setString('token', token);
    await p.setString('user', jsonEncode(user.toJson()));
  }

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _token = p.getString('token');
    final u = p.getString('user');
    if (u != null) _user = AppUser.fromJson(jsonDecode(u));
  }

  static Future<void> clear() async {
    _token = null;
    _user = null;
    final p = await SharedPreferences.getInstance();
    await p.remove('token');
    await p.remove('user');
  }

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };
}

// ─── API SERVICE ──────────────────────────────────────────────────────────────
class ApiService {
  static Uri _uri(String path) => Uri.parse('$kBaseUrl$path');

  static Future<Map<String, dynamic>> _post(String path, Map body,
      {bool auth = false}) async {
    final res = await http
        .post(_uri(path),
            headers:
                auth ? Session.headers : {'Content-Type': 'application/json'},
            body: jsonEncode(body))
        .timeout(const Duration(seconds: 15));
    return jsonDecode(res.body);
  }

  static Future<dynamic> _get(String path,
      {bool auth = false, Map<String, String>? params}) async {
    final uri = params != null
        ? Uri.parse('$kBaseUrl$path').replace(queryParameters: params)
        : _uri(path);
    final res = await http
        .get(uri,
            headers:
                auth ? Session.headers : {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 15));
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> _put(String path, Map body) async {
    final res = await http
        .put(_uri(path), headers: Session.headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 15));
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> _delete(String path) async {
    final res = await http
        .delete(_uri(path), headers: Session.headers)
        .timeout(const Duration(seconds: 15));
    return jsonDecode(res.body);
  }

  // ── AUTH ─────────────────────────────────────────────────────────────────────
  static Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String cropType,
    required String region,
  }) async {
    try {
      final r = await _post('/auth/register', {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'crop_type': cropType,
        'region': region,
      });
      if (r['token'] != null) {
        await Session.save(r['token'], AppUser.fromJson(r['user']));
        return null;
      }
      return r['error'] ?? 'Registration failed';
    } catch (e) {
      return 'Cannot connect to server. Check your WiFi.';
    }
  }

  static Future<String?> login(String email, String password) async {
    try {
      final r =
          await _post('/auth/login', {'email': email, 'password': password});
      if (r['token'] != null) {
        await Session.save(r['token'], AppUser.fromJson(r['user']));
        return null;
      }
      return r['error'] ?? 'Login failed';
    } catch (e) {
      return 'Cannot connect to server. Check your WiFi.';
    }
  }

  static Future<void> logout() => Session.clear();

  static Future<String?> forgotPassword(String email) async {
    try {
      await _post('/auth/forgot-password', {'email': email});
      return null;
    } catch (e) {
      return 'Cannot connect to server';
    }
  }

  static Future<String?> updateProfile(Map<String, dynamic> data) async {
    try {
      await _put('/auth/profile', data);
      return null;
    } catch (e) {
      return 'Update failed';
    }
  }

  // ── REMINDERS ────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getReminders() async {
    try {
      final r = await _get('/reminders', auth: true);
      return List<Map<String, dynamic>>.from(r);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> createReminder(Map<String, dynamic> data) async {
    try {
      await _post('/reminders', data, auth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateReminder(int id, Map<String, dynamic> data) async {
    try {
      await _put('/reminders/$id', data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteReminder(int id) async {
    try {
      await _delete('/reminders/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MARKET ───────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getProducts(
      {String category = 'All'}) async {
    try {
      final r = await _get('/market/products',
          params: category == 'All' ? {} : {'category': category});
      return List<Map<String, dynamic>>.from(r);
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getMyProducts() async {
    try {
      final r = await _get('/market/my-products', auth: true);
      return List<Map<String, dynamic>>.from(r);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> createProduct(Map<String, dynamic> data) async {
    try {
      await _post('/market/products', data, auth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      await _put('/market/products/$id', data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      await _delete('/market/products/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MACHINES ─────────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getMachines() async {
    try {
      final r = await _get('/machines');
      return List<Map<String, dynamic>>.from(r);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> createMachine(Map<String, dynamic> data) async {
    try {
      await _post('/machines', data, auth: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteMachine(int id) async {
    try {
      await _delete('/machines/$id');
      return true;
    } catch (e) {
      return false;
    }
  }
}
