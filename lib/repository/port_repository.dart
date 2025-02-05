import 'package:bagreportun/model/port.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../SQLite/database_helper.dart';

class PortRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insert Port Data
  Future<int> insertPort(Port port) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'Port',
      port.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get All Ports
  Future<List<Port>> getPorts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Port');
    return maps.map((map) => Port.fromMap(map)).toList();
  }

  // Get Single Port by ID
  Future<Port?> getPortById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
    await db.query('Port', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Port.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update Port
  Future<int> updatePort(int id, Map<String, dynamic> port) async {
    final db = await _dbHelper.database;
    return await db.update('Port', port, where: 'id = ?', whereArgs: [id]);
  }

  // Delete Port
  Future<int> deletePort(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('Port', where: 'id = ?', whereArgs: [id]);
  }
}


// Similarly, repositories can be created for Shift, Reading, and User tables

// void main() async {
// //   // Ensuring database initialization before using
// //   WidgetsFlutterBinding.ensureInitialized();
// //
// //   final portRepo = PortRepository();
// //
// //   // Example usage of PortRepository
// //   final newPort = {
// //     'port_name': 'COM1',
// //     'baud_rate': 9600,
// //     'data_bits': 8,
// //     'parity': 'None',
// //     'stop_bits': 1
// //   };
// //
// //   // Insert a new port
// //   int portId = await portRepo.insertPort(newPort);
// //   print('Inserted Port ID: $portId');
// //
// //   // Retrieve all ports
// //   List<Map<String, dynamic>> ports = await portRepo.getPorts();
// //   print('Ports: $ports');
// //
// //   // Update a port
// //   final updatedPort = {
// //     'port_name': 'COM2',
// //     'baud_rate': 115200,
// //     'data_bits': 8,
// //     'parity': 'Even',
// //     'stop_bits': 1
// //   };
// //   await portRepo.updatePort(portId, updatedPort);
// //
// //   // Delete a port
// //   await portRepo.deletePort(portId);
// // }