import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Servicio de base de datos que maneja la persistencia de datos con SQLite.
class DBService {
  // Instancia única de la base de datos (Singleton)
  static final DBService _instance = DBService._();
  static Database? _database;

  // Constructor privado para evitar múltiples instancias
  DBService._();

  // Método de fábrica para obtener la instancia única
  factory DBService() => _instance;

  /// Obtiene la instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos y crea las tablas necesarias si no existen.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'app_data.db'),
      version: 1,
      onCreate: (db, version) {
        // Crear tabla de usuario
        db.execute('''
          CREATE TABLE first_time (
            is_firstTime Boolean NOT NULL DEFAULT true
          )
        ''');

        // Crear tabla de ubicaciones favoritas
        db.execute('''
          CREATE TABLE favorite_locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            city_name TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL
          )
        ''');

        // Crear tabla de búsquedas recientes
        db.execute('''
          CREATE TABLE recent_searches (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            city_name TEXT NOT NULL UNIQUE, 
            search_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }

  // ========================
  // MÉTODOS PARA LA TABLA "FIRST_TIME"
  // ========================

  Future<bool> isFirstTime() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('first_time', where: 'is_firstTime = true');

    return result.isNotEmpty;
  }

  Future<int> setFirstTimeFalse() async {
    final db = await database;

    return  await db.update('first_time', { 'is_firstTime': false});
  }

  // ========================
  // MÉTODOS PARA LA TABLA "FAVORITE_LOCATIONS"
  // ========================

  /// Inserta una nueva ubicación favorita en la base de datos.
  Future<int> insertFavorite(String cityName, double lat, double lon) async {
    final db = await database;
    return await db.insert('favorite_locations', {
      'city_name': cityName,
      'latitude':
          double.parse(lat.toStringAsFixed(2)), // Redondeo a 2 decimales
      'longitude': double.parse(lon.toStringAsFixed(2)),
    });
  }

  /// Obtiene la lista de ubicaciones favoritas ordenadas por el ID en orden descendente.
  Future<List<Map<String, dynamic>>> fetchFavorites() async {
    final db = await database;
    return await db.query('favorite_locations', orderBy: 'id DESC');
  }

  /// Elimina una ubicación favorita de la base de datos.
  Future<void> deleteFavorite(String cityName, double lat, double lon) async {
    final db = await database;
    double roundedLat = double.parse(lat.toStringAsFixed(2));
    double roundedLon = double.parse(lon.toStringAsFixed(2));

    await db.delete(
      'favorite_locations',
      where:
          'city_name = ? AND ROUND(latitude, 2) = ? AND ROUND(longitude, 2) = ?',
      whereArgs: [cityName, roundedLat, roundedLon],
    );
  }

  /// Verifica si una ciudad está marcada como favorita.
  Future<bool> isCityFavorite(String cityName, double lat, double lon) async {
    final db = await database;
    double roundedLat = double.parse(lat.toStringAsFixed(2));
    double roundedLon = double.parse(lon.toStringAsFixed(2));

    final List<Map<String, dynamic>> result = await db.query(
      'favorite_locations',
      where:
          'city_name = ? AND ROUND(latitude, 2) = ? AND ROUND(longitude, 2) = ?',
      whereArgs: [cityName, roundedLat, roundedLon],
    );

    return result.isNotEmpty;
  }

  // ========================
  // MÉTODOS PARA LA TABLA "RECENT_SEARCHES"
  // ========================

  /// Inserta una búsqueda reciente en la base de datos.
  /// Si la ciudad ya existe en la lista de búsquedas recientes, la reemplaza.
  Future<void> insertRecentSearch(String cityName) async {
    final db = await database;
    await db.insert(
      'recent_searches',
      {'city_name': cityName},
      conflictAlgorithm: ConflictAlgorithm.replace, // Reemplaza si ya existe
    );
  }

  /// Obtiene las últimas búsquedas recientes (por defecto, las 5 más recientes).
  Future<List<String>> fetchRecentSearches({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'recent_searches',
      orderBy: 'search_date DESC',
      limit: limit,
    );

    return result.map((row) => row['city_name'] as String).toList();
  }

  /// Borra todas las búsquedas recientes de la base de datos.
  Future<void> clearRecentSearches() async {
    final db = await database;
    await db.delete('recent_searches');
  }
}
