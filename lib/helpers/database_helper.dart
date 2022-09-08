import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  //Metodo asincrono que regresa un Future de tipo Database, si la base de datos no ha sido creada llama al metodo _init..., primera vez que se corre se genera luego ya no
  Future<Database> get database async => _database ??= await _initDatase();

  Future<Database> _initDatase() async {
    //specify a location in your phone to store the data base
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //directorio donde se guardan los archivos
    String path = join(documentsDirectory.path, 'animals.db');
    //si no existe openDatabase crea la base de datos
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
}
