import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Movie {
  int? id;
  String movieName;
  String directorName;
  String bannerImage;

  Movie(
      {this.id,
      required this.movieName,
      required this.bannerImage,
      required this.directorName});

  factory Movie.fromMap(Map<String, dynamic> json) => new Movie(
      id: json['id'],
      movieName: json['movieName'],
      bannerImage: json['bannerImage'],
      directorName: json['directorName']);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['movieName'] = movieName;
    map['directorName'] = directorName;
    map['bannerImage'] = bannerImage;
    map['id'] = id;
    return map;
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'moviesList.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE moviesList(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      movieName TEXT,
      directorName TEXT,
      bannerImage TEXT
    )''');
  }

  Future<List<Movie>> getMovies() async {
    Database db = await instance.database;
    var movies = await db.query('moviesList', orderBy: 'id');
    List<Movie> movieList =
        movies.isNotEmpty ? movies.map((e) => Movie.fromMap(e)).toList() : [];
    return movieList;
  }

  Future<int> addMovie(Movie movie) async {
    Database db = await instance.database;
    return await db.insert('moviesList', movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteMovie(int id) async {
    Database db = await instance.database;
    return await db.delete('moviesList', where: 'id=?', whereArgs: [id]);
  }

  Future<int> updateMovie(Movie movie) async {
    Database db = await instance.database;
    return await db.update('moviesList', movie.toMap(),
        where: 'id=?',
        whereArgs: [movie.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
