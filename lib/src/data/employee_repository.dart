import 'dart:async';
import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/emplyee_model.dart';


class EmployeeRepository {
  late Database _database;

  Future<void> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'employees.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees(
            slno INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            role TEXT,
            today TEXT,
            noDate TEXT
          )
        ''');
      },
    );

    print(_database.isOpen);
  }

  Future<List<Employee>> getAllEmployees() async {
    final List<Map<String, dynamic>> employees = await _database.query('employees');
    return employees.map((e) => Employee.fromJson(e)).toList();
  }

  Future<void> insertEmployee(Employee employee) async {
    try {
      final result = await _database.insert('employees', employee.toJson());
      log(result.toString());
    } catch (e) {
      log("Error at insertEmployee $e");
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    await _database.update(
      'employees',
      employee.toJson(),
      where: 'slno = ?',
      whereArgs: [employee.slno],
    );
  }

  Future<void> deleteEmployee(int id) async {
    await initializeDatabase();
    await _database.delete(
      'employees',
      where: 'slno = ?',
      whereArgs: [id],
    );
  }
}
