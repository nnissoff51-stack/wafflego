import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/activity_log.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wafflego.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        role TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Activity logs table
    await db.execute('''
      CREATE TABLE activity_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        staffName TEXT NOT NULL,
        orderId TEXT NOT NULL,
        action TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        details TEXT
      )
    ''');

    // Insert default owner account (temporary credentials)
    await db.insert('users', {
      'username': 'owner',
      'password': 'owner123', // Temporary password
      'fullName': 'Admin Owner',
      'role': 'owner',
      'createdAt': DateTime.now().toIso8601String(),
      'isActive': 1,
    });

    // Insert sample staff for testing
    await db.insert('users', {
      'username': 'ali',
      'password': 'ali123',
      'fullName': 'Ali Ahmad',
      'role': 'staff',
      'createdAt': DateTime.now().toIso8601String(),
      'isActive': 1,
    });

    await db.insert('users', {
      'username': 'alin',
      'password': 'alin123',
      'fullName': 'Alin Binti Hassan',
      'role': 'staff',
      'createdAt': DateTime.now().toIso8601String(),
      'isActive': 1,
    });
  }

  // ==================== USER OPERATIONS ====================

  // Authenticate user
  Future<User?> login(String username, String password) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ? AND password = ? AND isActive = 1',
      whereArgs: [username, password],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final results = await db.query('users', orderBy: 'createdAt DESC');
    return results.map((map) => User.fromMap(map)).toList();
  }

  // Get all staff (excluding owner)
  Future<List<User>> getAllStaff() async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: ['staff'],
      orderBy: 'createdAt DESC',
    );
    return results.map((map) => User.fromMap(map)).toList();
  }

  // Get active staff only
  Future<List<User>> getActiveStaff() async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'role = ? AND isActive = 1',
      whereArgs: ['staff'],
      orderBy: 'fullName ASC',
    );
    return results.map((map) => User.fromMap(map)).toList();
  }

  // Add new user
  Future<int> addUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Update user
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete user (soft delete - set isActive to 0)
  Future<int> deleteUser(int userId) async {
    final db = await database;
    return await db.update(
      'users',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Hard delete user (permanent)
  Future<int> permanentDeleteUser(int userId) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty;
  }

  // ==================== ACTIVITY LOG OPERATIONS ====================

  // Add activity log
  Future<int> addActivityLog(ActivityLog log) async {
    final db = await database;
    return await db.insert('activity_logs', log.toMap());
  }

  // Get all activity logs
  Future<List<ActivityLog>> getAllActivityLogs() async {
    final db = await database;
    final results = await db.query(
      'activity_logs',
      orderBy: 'timestamp DESC',
    );
    return results.map((map) => ActivityLog.fromMap(map)).toList();
  }

  // Get activity logs by staff name
  Future<List<ActivityLog>> getActivityLogsByStaff(String staffName) async {
    final db = await database;
    final results = await db.query(
      'activity_logs',
      where: 'staffName = ?',
      whereArgs: [staffName],
      orderBy: 'timestamp DESC',
    );
    return results.map((map) => ActivityLog.fromMap(map)).toList();
  }

  // Get activity logs by date range
  Future<List<ActivityLog>> getActivityLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final results = await db.query(
      'activity_logs',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'timestamp DESC',
    );
    return results.map((map) => ActivityLog.fromMap(map)).toList();
  }

  // Get today's activity logs
  Future<List<ActivityLog>> getTodayActivityLogs() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return await getActivityLogsByDateRange(startOfDay, endOfDay);
  }

  // Clear all activity logs (for testing/maintenance)
  Future<int> clearActivityLogs() async {
    final db = await database;
    return await db.delete('activity_logs');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}