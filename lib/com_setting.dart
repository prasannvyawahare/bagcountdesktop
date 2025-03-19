import 'package:flutter/material.dart';




class ComSetting extends StatelessWidget {
  ComSetting({super.key});

  final TextEditingController portNameController =
      TextEditingController(text: "COM3");
  final TextEditingController baudRateController =
      TextEditingController(text: "4800");
  final TextEditingController dataBitsController =
      TextEditingController(text: "8");
  final TextEditingController parityController =
      TextEditingController(text: "None");
  final TextEditingController stopBitsController =
      TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text(
          "Configure Serial Port",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
       // backgroundColor: Colors.white70,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 300.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 20),
                    _buildTextField("Port Name", portNameController),
                    const SizedBox(height: 16),
                    _buildTextField("Baud Rate", baudRateController),
                    const SizedBox(height: 16),
                    _buildTextField("Data Bits", dataBitsController),
                    const SizedBox(height: 16),
                    _buildTextField("Parity", parityController),
                    const SizedBox(height: 16),
                    _buildTextField("Stop Bits", stopBitsController),
                    const Spacer(),
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
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label :",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 180,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
