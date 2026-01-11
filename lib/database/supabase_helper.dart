import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/activity_log.dart';

class SupabaseHelper {
  static final SupabaseHelper instance = SupabaseHelper._init();
  final _client = Supabase.instance.client;

  SupabaseHelper._init();

  // ==================== AUTH ====================

  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('username', username)
          .eq('password', password)
          .eq('is_active', true)
          .single();
      return UserModel.fromMap(response);
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // ==================== USER OPERATIONS ====================

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .order('created_at', ascending: false);
      return (response as List).map((u) => UserModel.fromMap(u)).toList();
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<List<UserModel>> getAllStaff() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('role', 'staff')
          .order('created_at', ascending: false);
      return (response as List).map((u) => UserModel.fromMap(u)).toList();
    } catch (e) {
      print('Error getting staff: $e');
      return [];
    }
  }

  Future<bool> usernameExists(String username) async {
    try {
      final res = await _client
          .from('users')
          .select()
          .eq('username', username)
          .limit(1);
      return (res as List).isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  Future<bool> addUser(UserModel user) async {
    try {
      await _client.from('users').insert(user.toMap());
      return true;
    } catch (e) {
      print('Error adding user: $e');
      return false;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      if (user.id == null) return false;
      await _client.from('users').update(user.toMap()).eq('id', user.id as Object);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      await _client.from('users').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // ==================== ACTIVITY LOGS ====================

  Future<bool> addActivityLog(ActivityLogModel log) async {
    try {
      await _client.from('activity_logs').insert(log.toMap());
      return true;
    } catch (e) {
      print('Error adding activity log: $e');
      return false;
    }
  }

  Future<List<ActivityLogModel>> getAllActivityLogs() async {
    try {
      final response = await _client
          .from('activity_logs')
          .select()
          .order('created_at', ascending: false);
      return (response as List).map((e) => ActivityLogModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting all activity logs: $e');
      return [];
    }
  }

  Future<List<ActivityLogModel>> getTodayActivityLogs() async {
    try {
      final today = DateTime.now().toUtc();
      final start = DateTime.utc(today.year, today.month, today.day);
      final end = start.add(const Duration(days: 1));

      final response = await _client
          .from('activity_logs')
          .select()
          .gte('created_at', start.toIso8601String())
          .lt('created_at', end.toIso8601String())
          .order('created_at', ascending: false);

      return (response as List).map((e) => ActivityLogModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting today activity logs: $e');
      return [];
    }
  }

  Future<List<ActivityLogModel>> getActivityLogsByDateRange(DateTime start, DateTime end) async {
    try {
      final response = await _client
          .from('activity_logs')
          .select()
          .gte('created_at', start.toIso8601String())
          .lt('created_at', end.toIso8601String())
          .order('created_at', ascending: false);

      return (response as List).map((e) => ActivityLogModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting activity logs by range: $e');
      return [];
    }
  }
}
