import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category.dart';
import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo_category.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        isDone INTEGER NOT NULL DEFAULT 0,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE SET NULL
      )
    ''');
  }

  // -------------------- CRUD TODO --------------------

  Future<int> insertTodo(Todo todo) async {
    try {
      final db = await database;
      return db.insert(
        'todos',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      throw Exception('Gagal menambahkan tugas: ${e.toString()}');
    }
  }

  Future<List<Todo>> getAllTodos({int? categoryId}) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
      SELECT todos.*, categories.name AS categoryName
      FROM todos
      LEFT JOIN categories ON todos.categoryId = categories.id
      ${categoryId == null ? '' : 'WHERE todos.categoryId = ?'}
      ORDER BY todos.createdAt DESC
      ''',
      categoryId == null ? [] : [categoryId],
    );

    return result.map((map) => Todo.fromMap(map)).toList();
  }

  Future<Todo?> getTodoById(int id) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT todos.*, categories.name AS categoryName
      FROM todos
      LEFT JOIN categories ON todos.categoryId = categories.id
      WHERE todos.id = ?
      LIMIT 1
      ''',
      [id],
    );

    if (result.isEmpty) return null;
    return Todo.fromMap(result.first);
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> toggleTodoStatus(int id, bool isDone) async {
    final db = await database;
    return db.update(
      'todos',
      {'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearCompletedTodos() async {
    final db = await database;
    return db.delete(
      'todos',
      where: 'isDone = ?',
      whereArgs: [1],
    );
  }

  // -------------------- CRUD CATEGORY --------------------

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final result = await db.query(
      'categories',
      orderBy: 'name ASC',
    );
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
