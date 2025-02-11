import 'dart:async';
import 'dart:ffi';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import '../model/reading.dart';
import '../model/reading_count.dart';
import '../model/reading_with_count.dart';
import '../repository/reading_count_repository.dart';
import '../repository/reading_repository.dart';
import '../util/constant_string.dart';
import '../util/shared_pref_helper.dart';

class SerialPortService extends GetxController  {
  static SerialPortService get instance => Get.find();

  RxList<ReadingWithCount> readingWithCountList = <ReadingWithCount>[].obs; // List to store readings
  SerialPort? _serialPort;
  final StreamController<String> _dataController = StreamController<String>.broadcast();
  bool isConnected = false;
  StreamSubscription? _dataSubscription;
  final readingRepository = ReadingRepository();
  final readingCountRepository = ReadingCountRepository();
  Stream<String> get dataStream => _dataController.stream;
  //String oldCount='';
  String newCount='';
  Timer? _debounceTimer1;
  Timer? _debounceTimer2;
  final Map<int, String> _lastCounts = {};
  int _currentReadingId = 0;





  @override
  void onInit() {
    super.onInit();
    getAllReadingData();
  }

  Future<bool> connectSerialPort({
    required String portName,
    required int baudRate,
    required int dataBits,
    required String parity,
    required int stopBits,
  })
  async {

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
        String _buffer = '';
        String _buffer2 = '';
        String currentReading='';
        int readingId=0;
        _dataSubscription = reader.stream.listen(

              (data) async {
               //await readingRepository.deleteAllReadings();
                String receivedData = String.fromCharCodes(data);
                _dataController.add(receivedData); // Send data to stream
                _buffer += receivedData;

                if(_buffer.startsWith("*") && _buffer.length == 22){
                  currentReading=_buffer;
                  readingId= await parseRawData(_buffer);
                  _currentReadingId=readingId;
                  _buffer='';
                }

                _debounceTimer1?.cancel();
                _debounceTimer1 = Timer(Duration(seconds: 3), () async {
                  RegExp regex = RegExp(r"[$#](-?\d+)"); // Updated regex
                  Iterable<Match> matches = regex.allMatches(_buffer);
                  print("_buffer $_buffer");
                  for (Match match in matches) {
                    String counterValue = match.group(1)!;
                    if (_currentReadingId == 0) continue;
                    print("counterValue $counterValue");
                    if (_lastCounts[_currentReadingId] != counterValue) {
                      var readingCount = ReadingCount(
                        count: counterValue,
                        readingId: _currentReadingId,
                        timestamp: DateTime.now().toIso8601String(),
                      );
                      var hash = await readingCountRepository.insertReadingCount(readingCount);
                      print("hash* $hash");
                      _lastCounts[_currentReadingId] = counterValue;
                    }
                  }
                  _buffer = '';
                });



                // _debounceTimer1?.cancel();
                // _debounceTimer1 = Timer(Duration(seconds: 3), () async {
                //   RegExp regex = RegExp(r"#(-?\d+)");
                //   Iterable<Match> matches = regex.allMatches(_buffer);
                //   print("_buffer $_buffer");
                //   for (Match match in matches) {
                //     String counterValue = match.group(1)!;
                //     if (_currentReadingId == 0) continue;
                //   print("counterValue# $counterValue");
                //     if (_lastCounts[_currentReadingId] != counterValue) {
                //       var readingCount = ReadingCount(
                //         count: counterValue,
                //         readingId: _currentReadingId,
                //         timestamp: DateTime.now().toIso8601String(),
                //       );
                //       var hash=await readingCountRepository.insertReadingCount(readingCount);
                //       print("hash* $hash");
                //       _lastCounts[_currentReadingId] = counterValue;
                //     }
                //   }
                //   _buffer = '';
                // });

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

  Future<void> disconnect() async {
    if (_serialPort != null && _serialPort!.isOpen) {
      _serialPort!.close();
      _serialPort = null;
    }
    await SharedPrefHelper.saveBool(SharedPrefKeys.isConnect, false);
    isConnected = false;
    _dataSubscription?.cancel();
    _dataSubscription = null;
    // if (!_dataController.isClosed) {
    //   _dataController.close();
    // }
  }
  Future<int> parseRawData(String rawData) async {
   // print(rawData);
    if (!rawData.startsWith('*')) {
      throw Exception('Invalid Data Format');
    }

    try {
      rawData = rawData.replaceAll('*', ''); // Remove start character
      List<String> parts = rawData.split(RegExp(r'[\$\#]')); // Split at $ and #

      String dataPart = parts[0]; // Main data
      String counterStatus = parts.length > 1 ? parts[1] : ""; // Counter status before #

      // Extract values
      String bay = dataPart.substring(0, 2); // First 2 digits = Bay
      String truckNo = dataPart.substring(2, 6); // Next 4 digits = Truck No.
      String brand = dataPart.substring(6, 9); // Next 3 characters = Brand
      double mrp =double.parse( dataPart.substring(9, 12)); // Next 3 digits = MRP
      double ton = (int.parse(dataPart.substring(12, 15)) / 10).toDouble(); // Next 3 digits = Ton (divided by 10)
if(bay=='10'){
  bay="01";
}else{
  bay="02";
}

     final timestamp=DateTime.now().toIso8601String();
     final reading = Reading(
       timestamp: timestamp,
       bay: bay,
       truckNo: truckNo,
       brand: brand,
       mrp: mrp,
       ton: ton);

     return await readingRepository.insertReading(reading);
      // return TruckData(
      //   bay: bay,
      //   truckNo: truckNo,
      //   brand: brand,
      //   mrp: mrp,
      //   ton: ton,
      //   counterStatus: counterStatus,
      // );
    } catch (e) {
      throw Exception('Error parsing data: $e');
    }
  }

  getAllReadingData() async {
    // final readings = await readingRepository.getAllReadings();
    // readingList.assignAll(readings.reversed.toList());

    List<ReadingWithCount> readingsWithC = await readingRepository.getCombinedReadings();
    readingWithCountList.assignAll(readingsWithC.reversed.toList());
    for (var reading in readingsWithC) {
      print("Reading ID: ${reading.reading.id}, Bay: ${reading.reading.bay}, Truck No: ${reading.reading.truckNo}");
      print("Count: ${reading.count}, Count Timestamp: ${reading.readingCountTimestamp}");
    }

  }


  void closeDb() async {
    await readingRepository. closeDb();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disconnect();
    closeDb();
    super.dispose();
  }
}
