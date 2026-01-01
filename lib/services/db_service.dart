import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;

  DBService._internal();

  Database? _database;

  /// Getter to access the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tourpackage.db'),
      version: 3, // Update version when schema changes
      onUpgrade: (db, oldVersion, newVersion) async {
        print("onUpgrade called from version $oldVersion to $newVersion");
        if (oldVersion < 3) {
          // Create or update the `tours` table during upgrade
          await db.execute('''
          CREATE TABLE IF NOT EXISTS tours (
            tourcode TEXT PRIMARY KEY,
            title TEXT,
            image TEXT,
            price REAL
          );
          ''');
          print("`tours` table created/verified in onUpgrade");
        }
      },
      onCreate: (db, version) async {
        print("onCreate called with version $version");

        // Create `users` table
        await db.execute('''
        CREATE TABLE users (
          userid INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          phone TEXT,
          username TEXT UNIQUE,
          password TEXT
        );
        ''');

        // Create `administrator` table
        await db.execute('''
        CREATE TABLE administrator (
          adminid INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT
        );
        ''');
        // Create `tours` table
        await db.execute('''
        CREATE TABLE IF NOT EXISTS tours (
          tourcode TEXT PRIMARY KEY,
          title TEXT,
          image TEXT,
          price REAL
        );
        ''');

        // Insert default admin credentials
        await db.insert(
          'administrator',
          {'username': 'admin', 'password': 'admin123'},
        );
        print("Default administrator created");
      },
    );
  }
}
