import 'package:flutter/material.dart';

class ShiftSettingScreen extends StatefulWidget {
  const ShiftSettingScreen({super.key});

  @override
  State<ShiftSettingScreen> createState() => _ShiftSettingScreenState();
}

class _ShiftSettingScreenState extends State<ShiftSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shift Settings"  ,style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),),
        centerTitle: true,
      ),
      body: Container(
       color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 30),
                  // Shift A
                  _buildShiftRow('Shift A', '00:00', '08:00'),
                  const SizedBox(height: 30),
                  // Shift B
                  _buildShiftRow('Shift B', '08:00', '16:00'),
                  const SizedBox(height: 30),
                  // Shift C
                  _buildShiftRow('Shift C', '16:00', '23:59'),
                  const SizedBox(height: 50),

                  Center(
                    child:  SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: Text("SAVE", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShiftRow(String shiftName, String startHint, String endHint) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$shiftName: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          _buildTextField(startHint),
          const SizedBox(width: 10),
          const Text('To', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          _buildTextField(endHint),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return SizedBox(
      width: 100,
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
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
    );
  }
}
