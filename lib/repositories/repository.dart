import 'package:todolist/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository
{
  DatabaseConnection _databaseConnection;
  Repository()
  {
    //initialize database connection
    _databaseConnection = DatabaseConnection();
  }
  static Database _database;

  Future<Database> get database async
  {
    if(_database != null)return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }
  //Inserting into the database
  insertData(table , data) async
  {
    var connection = await database;
    return await connection.insert(table, data);
  }
  //Reading data from the table
  readData(table) async 
  {
    var connection = await database;
    return await connection.query(table);
  }

  readDataById(table , itemId) async
  {
    var connection = await database;
    return await connection.query(table , where: 'id=?' , whereArgs: [itemId]);
  }

  updateData(table , data) async {
    var connection = await database;
    return await connection.update(table, data , where:'id=?' , whereArgs: [data['id']]);
  }

  deleteData(table , itemId) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }

  //Read data from table by Column name
  readDataByColumnName(table , columnName ,columnValue) async{
    var connection = await database;
    return await connection.query(table , where : '$columnName=?' , whereArgs : [columnValue]);
  }
}