import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ComSetting extends StatefulWidget {
  const ComSetting({super.key});

  @override
  _ComSettingState createState() => _ComSettingState();
}

class _ComSettingState extends State<ComSetting> {
  final TextEditingController baudRateController = TextEditingController(text: "4800");
  final TextEditingController dataBitsController = TextEditingController(text: "8");
  final TextEditingController parityController = TextEditingController(text: "None");
  final TextEditingController stopBitsController = TextEditingController(text: "1");

  late SerialPort _serialPort;
  String? selectedPort;
  List<String> availablePorts = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailablePorts();
  }

  @override
  void dispose() {
    // Close the port when the widget is disposed
    _serialPort.close();
    super.dispose();
  }

  // Fetch available ports
  Future<void> _fetchAvailablePorts() async {
    List<String> ports = SerialPort.availablePorts;
    setState(() {
      availablePorts = ports;
      if (ports.isNotEmpty) {
        selectedPort = ports[0]; // Select the first port by default
      }
    });
  }

  // Function to connect to the selected serial port
  void _connectSerialPort() {
    if (selectedPort == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No port selected')),
      );
      return;
    }

    int baudRate = int.tryParse(baudRateController.text) ?? 4800;
    int dataBits = int.tryParse(dataBitsController.text) ?? 8;
    String parity = parityController.text;
    int stopBits = int.tryParse(stopBitsController.text) ?? 1;

    // Create and open the selected serial port
    _serialPort = SerialPort(selectedPort!);

    if (!_serialPort.isOpen) {
      final opened = _serialPort.openReadWrite();
      if (opened) {
        _serialPort.config.baudRate = baudRate;
        _serialPort.config.bits = dataBits;
        _serialPort.config.parity = _getParity(parity);
        _serialPort.config.stopBits = stopBits;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected to $selectedPort')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open port $selectedPort')),
        );
      }
    }
  }

  // Function to map string parity value to SerialPortParity
  int _getParity(String parity) {
    switch (parity.toLowerCase()) {
      case 'even':
        return SerialPortParity.even;
      case 'odd':
        return SerialPortParity.odd;
      case 'none':
      default:
        return SerialPortParity.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Configure Serial Port",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
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
                  const SizedBox(height: 20),
                  _buildPortSelector(),
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
                    child: Container(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _connectSerialPort,
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

  Widget _buildPortSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Port Name:",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        DropdownButton<String>(
          value: selectedPort,
          onChanged: (String? newPort) {
            setState(() {
              selectedPort = newPort;
            });
          },
          items: availablePorts.map<DropdownMenuItem<String>>((String port) {
            return DropdownMenuItem<String>(
              value: port,
              child: Text(port),
            );
          }).toList(),
          hint: Text("Select Port"),
        ),
      ],
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
