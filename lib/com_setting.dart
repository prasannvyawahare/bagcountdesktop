import 'dart:async';
import 'dart:convert';

import 'package:bagreportun/model/reading.dart';
import 'package:bagreportun/repository/port_repository.dart';
import 'package:bagreportun/repository/reading_repository.dart';
import 'package:bagreportun/util/constant_string.dart';
import 'package:bagreportun/util/serial_port_service.dart';
import 'package:bagreportun/util/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ComSetting extends StatefulWidget {
  const ComSetting({super.key});

  @override
  _ComSettingState createState() => _ComSettingState();
}

class _ComSettingState extends State<ComSetting> {
  final TextEditingController baudRateController =
      TextEditingController(text: "9600");
  final TextEditingController dataBitsController =
      TextEditingController(text: "8");
  final TextEditingController parityController =
      TextEditingController(text: "None");
  final TextEditingController stopBitsController =
      TextEditingController(text: "1");
  final ReadingRepository _readingRepository = ReadingRepository();

  List<Reading> readings = [];
  final portRepo = PortRepository();
  String _buffer = ''; // Temporary buffer to hold incomplete data
  String newReading = "No data Found";
  @override
  late Timer timer;
  String? selectedPort;
  bool isConnect = false;
  List<String> availablePorts = [];
  final SerialPortService _serialService = SerialPortService();

  @override
  void initState() {
    super.initState();
    init();
    _fetchAvailablePorts();
    _listenToSerialData();
  }

  Future<void> init() async {
    isConnect = await SharedPrefHelper.getBool(SharedPrefKeys.isConnect)??false;
    print(isConnect);
    if (mounted) {
      setState(() {
        // Your state update logic here
      });
    }

  }

  @override
  void dispose() {
    // Close the port when the widget is disposed
 //   _serialPort.close();
    super.dispose();
  }

  void readDataFromDB() async {
    readings = await _readingRepository.getAllReadings();
    print(readings);
  }

  // Fetch available ports
  Future<void> _fetchAvailablePorts() async {
    List<String> ports = SerialPort.availablePorts;
    if (mounted) {
      setState(() {
        availablePorts = ports;
        if (ports.isNotEmpty) {
          selectedPort = ports[0]; // Select the first port by default
        }
      });
    }

  }

  Future<void> _connectSerialPort() async {
    if (selectedPort == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No port selected')),
      );
      return;
    }
    if (isConnect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Already connected to $selectedPort')),
      );
      return;
    }
    bool isConnected = await _serialService.connectSerialPort(
      portName: selectedPort!,
      baudRate: int.tryParse(baudRateController.text) ?? 9600,
      dataBits: int.tryParse(dataBitsController.text) ?? 8,
      parity: parityController.text,
      stopBits: int.tryParse(stopBitsController.text) ?? 1,
    );
    print("isConnected : $isConnected");
    if (isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to $selectedPort')),
      );
      await SharedPrefHelper.saveBool(SharedPrefKeys.isConnect, true);
      isConnect = true;
      if (mounted) {
        setState(() {
          // Your state update logic here
        });
      }
    //  _navigateToDataScreen();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open port')),
      );
    }
  }

  void _listenToSerialData() {
    _serialService.dataStream.listen(
          (data) async {
         //
            if (mounted) {
              setState(() {
                newReading="";
                newReading+= data; // Append new data
              });
            }


      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      },
    );
  }

// Example function to save data to the database
  void _saveToDatabase(String data) async {
    // Assuming you have a SQLite database instance `db` and a table named `readings`
    final reading = Reading(
      value: data,
      timestamp: DateTime.now().toIso8601String(),unit: "bay1"
    );
    await _readingRepository.insertReading(reading);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('data added successfully from port $selectedPort')),
    );
    print('Data saved to database: $data');
    readDataFromDB();
  }

  Future<void> _disconnectSerialPort() async {
    if (isConnect) {
      _serialService.disconnect();
      await SharedPrefHelper.saveBool(SharedPrefKeys.isConnect, false);
      isConnect = (await SharedPrefHelper.getBool(SharedPrefKeys.isConnect))!;

      print("isConnect: $isConnect");
      //isConnect = false;
      readings.clear();
      if (mounted) {
        setState(() {
          // Your state update logic here
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Disconnected from $selectedPort')),
      );
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

  // Function to map string parity value to SerialPortParity
  int _getFlowController(String flowController) {
    switch (flowController.toLowerCase()) {
      case 'dtrDsr':
        return SerialPortFlowControl.dtrDsr;
      case 'rtsCts':
        return SerialPortFlowControl.rtsCts;
      case 'xonXoff':
        return SerialPortFlowControl.xonXoff;
      case 'none':
      default:
        return SerialPortFlowControl.none;
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  Text(
                    newReading,
                  ),
                  const Spacer(),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: _connectSerialPort,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isConnect?Colors.grey:Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                            ),
                            child: Text(isConnect?"Connected":"Connect",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 16),
                        isConnect
                            ? Container(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: _disconnectSerialPort,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                            ),
                            child: Text("Disconnect",
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                            : SizedBox(),
                      ],
                    ),
                  ),

                  // readings.length>0?Container(
                  //   height: 300,
                  //   child: ListView.builder(
                  //     itemCount: readings.length,
                  //     itemBuilder: (context, index) {
                  //       return ListTile(
                  //         title: Text(readings[index].value.toString()),
                  //       );
                  //     },
                  //   ),
                  // ):Container(
                  //   child: Center(
                  //     child: Text("No Data Found"),
                  //   ),
                  // ),
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
            enabled: !isConnect,
            decoration: InputDecoration(
              filled: true,
              fillColor: isConnect ? Colors.grey[300] : Colors.grey[200], // Visual cue
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
