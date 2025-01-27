import 'package:bagreportun/repository/shift_repository.dart';
import 'package:flutter/material.dart';
import 'model/shift.dart';
import 'SQLite/database_helper.dart';

class ShiftSettingScreen extends StatefulWidget {
  const ShiftSettingScreen({super.key});

  @override
  State<ShiftSettingScreen> createState() => _ShiftSettingScreenState();
}

class _ShiftSettingScreenState extends State<ShiftSettingScreen> {
  final ShiftRepository _shiftRepository = ShiftRepository();

  // Controllers for adding shifts
  final TextEditingController _shiftNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  late Future<List<Shift>> _shiftList;

  @override
  void initState() {
    super.initState();
    _loadShifts();
  }

  // Load all shifts from the database
  void _loadShifts() {
    _shiftList = _shiftRepository.getAllShifts();
    setState(() {}); // Refresh the UI to display the loaded shifts
  }

  // Add a new shift
  void _addShift() async {
    final shift = Shift(
      shiftName: _shiftNameController.text,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
    );

    await _shiftRepository.insertShift(shift);

    // Clear the text fields
    _shiftNameController.clear();
    _startTimeController.clear();
    _endTimeController.clear();

    // Reload shifts after adding
    _loadShifts();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Shift added successfully")));
  }

  // Function to show time picker dialog and update the controller with selected time
  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      controller.text = time.format(context);  // Update text controller with selected time
    }
  }

  // Delete shift
  Future<void> _deleteShift(int shiftId) async {
    bool confirmDelete = await _showDeleteDialog(context);
    if (confirmDelete) {
      await _shiftRepository.deleteShift(shiftId);
      _loadShifts();  // Reload shifts after deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Shift deleted successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shift Settings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // New shift input form
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField('Shift Name', _shiftNameController),
                      const SizedBox(height: 10),
                      _buildTimeField('Start Time', _startTimeController),
                      const SizedBox(height: 10),
                      _buildTimeField('End Time', _endTimeController),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addShift,
                        child: const Text("Add Shift"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Shift list display
              const Text(
                "Existing Shifts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Displaying shift list
              Expanded(
                child: FutureBuilder<List<Shift>>(
                  future: _shiftList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final shifts = snapshot.data!;
                      if (shifts.isEmpty) {
                        return Center(child: Text("No shifts available"));
                      }
                      return ListView.builder(
                        itemCount: shifts.length,
                        itemBuilder: (context, index) {
                          final shift = shifts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            child: ListTile(
                              title: Text(shift.shiftName),
                              subtitle: Text('From: ${shift.startTime} To: ${shift.endTime}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteShift(shift.id!),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text("No shifts available"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method for building text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  // Reusable method for building time picker fields
  Widget _buildTimeField(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () => _selectTime(controller),  // Trigger time picker on tap
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // Function to show delete confirmation dialog
  Future<bool> _showDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Shift'),
          content: const Text('Are you sure you want to delete this shift?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
