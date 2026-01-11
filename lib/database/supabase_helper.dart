import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/activity_log.dart';

class SupabaseHelper {
  static final SupabaseHelper instance = SupabaseHelper._init();
  final _client = Supabase.instance.client;

  SupabaseHelper._init();

  // ==================== USER OPERATIONS ====================

  // Login / Authenticate user
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('username', username)
          .eq('password', password) // In production, use proper password hashing!
          .eq('is_active', true)
          .single();

      return UserModel.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((user) => UserModel.fromMap(user))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get all staff (excluding owner)
  Future<List<UserModel>> getAllStaff() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('role', 'staff')
          .order('created_at', ascending: false);

      return (response as List)
          .map((user) => UserModel.fromMap(user))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get active staff only
  Future<List<UserModel>> getActiveStaff() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('role', 'staff')
          .eq('is_active', true)
          .order('full_name', ascending: true);

      return (response as List)
          .map((user) => UserModel.fromMap(user))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add new user
  Future<bool> addUser(UserModel user) async {
    try {
      await _client.from('users').insert(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update user
  Future<bool> updateUser(UserModel user) async {
    try {
      await _client
          .from('users')
          .update(user.toMap())
          .eq('id', user.id!);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete user (soft delete - set is_active to false)
  Future<bool> deleteUser(String userId) async {
    try {
      await _client
          .from('users')
          .update({'is_active': false})
          .eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Hard delete user (permanent)
  Future<bool> permanentDeleteUser(String userId) async {
    try {
      await _client
          .from('users')
          .delete()
          .eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    try {
      final response = await _client
          .from('users')
          .select('id')
          .eq('username', username);

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ==================== ACTIVITY LOG OPERATIONS ====================

  // Add activity log
  Future<bool> addActivityLog(ActivityLogModel log) async {
    try {
      await _client.from('activity_logs').insert(log.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all activity logs
  Future<List<ActivityLogModel>> getAllActivityLogs() async {
    try {
      final response = await _client
          .from('activity_logs')
          .select()
          .order('timestamp', ascending: false);

      return (response as List)
          .map((log) => ActivityLogModel.fromMap(log))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get activity logs by staff name
  Future<List<ActivityLogModel>> getActivityLogsByStaff(String staffName) async {
    try {
      final response = await _client
          .from('activity_logs')
          .select()
          .eq('staff_name', staffName)
          .order('timestamp', ascending: false);

      return (response as List)
          .map((log) => ActivityLogModel.fromMap(log))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get activity logs by date range
  Future<List<ActivityLogModel>> getActivityLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _client
          .from('activity_logs')
          .select()
          .gte('timestamp', startDate.toIso8601String())
          .lte('timestamp', endDate.toIso8601String())
          .order('timestamp', ascending: false);

      return (response as List)
          .map((log) => ActivityLogModel.fromMap(log))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get today's activity logs
  Future<List<ActivityLogModel>> getTodayActivityLogs() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return await getActivityLogsByDateRange(startOfDay, endOfDay);
  }

  // Clear all activity logs (for testing/maintenance)
  Future<bool> clearActivityLogs() async {
    try {
      await _client.from('activity_logs').delete().neq('id', '');
      return true;
    } catch (e) {
      return false;
    }
  }
}