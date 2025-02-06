import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../model/reading.dart';
import '../repository/reading_repository.dart';

class SerialPortService {
  SerialPort? _serialPort;
  final StreamController<String> _dataController = StreamController<String>.broadcast();
  bool isConnected = false;
  StreamSubscription? _dataSubscription;
  final readingRepository = ReadingRepository();
  Stream<String> get dataStream => _dataController.stream;

  Future<bool> connectSerialPort({
    required String portName,
    required int baudRate,
    required int dataBits,
    required String parity,
    required int stopBits,
  }) async {

    _serialPort = SerialPort(portName);
    // Cancel any existing subscription

    if (!_serialPort!.isOpen) {
      final opened = _serialPort!.openReadWrite();
      if (opened) {
        _serialPort!.config.baudRate = baudRate;
        _serialPort!.config.bits = dataBits;
        _serialPort!.config.parity = _getParity(parity);
        _serialPort!.config.stopBits = stopBits;
        _serialPort!.config.setFlowControl(SerialPortFlowControl.none);

        isConnected = true;
        await _dataSubscription?.cancel();
        // Start reading data
        final reader = SerialPortReader(_serialPort!);
        // Start listening to new data
        _dataSubscription = reader.stream.listen(
              (data) async {
            String receivedData = String.fromCharCodes(data);

            _dataController.add(receivedData); // Send data to stream

            final reading = Reading(
              timestamp: DateTime.now().toIso8601String(),
              value: receivedData, unit: 'bay1',
            );
            print('Reading: $reading');
            await readingRepository.insertReading(reading);

          },
          onError: (error) {
            disconnect();
            _dataController.addError('Error reading from serial port: $error');
          },
        );

        return true;
      }
    }
    return false;
  }

  int _getParity(String parity) {
    switch (parity.toLowerCase()) {
      case 'even':
        return SerialPortParity.even;
      case 'odd':
        return SerialPortParity.odd;
      default:
        return SerialPortParity.none;
    }
  }

  void disconnect() {
    if (_serialPort != null && _serialPort!.isOpen) {
      _serialPort!.close();
      _serialPort = null;
    }
    isConnected = false;
    _dataSubscription?.cancel();
    _dataSubscription = null;
    // if (!_dataController.isClosed) {
    //   _dataController.close();
    // }
  }

}
