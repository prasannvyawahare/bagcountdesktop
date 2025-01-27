import '../SQLite/database_helper.dart';

class PortRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertPort(Map<String, dynamic> port) async {
    final db = await _dbHelper.database;
    return await db.insert('Port', port);
  }

  Future<List<Map<String, dynamic>>> getPorts() async {
    final db = await _dbHelper.database;
    return await db.query('Port');
  }

  Future<int> updatePort(int id, Map<String, dynamic> port) async {
    final db = await _dbHelper.database;
    return await db.update('Port', port, where: 'id = ?', whereArgs: [id]);
  }

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