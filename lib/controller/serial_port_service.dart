import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
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
  final StreamController<String> _dataController = StreamController<String>.broadcast();
  bool isConnected = false;
  StreamSubscription? _dataSubscription;
  //final readingRepository = ReadingRepository();
 // final readingCountRepository = ReadingCountRepository();
  Stream<String> get dataStream => _dataController.stream;
  //String oldCount='';
  String newCount='';
  Timer? _debounceTimer1;
  Timer? _debounceTimer2;
  final Map<int, String> _lastCounts = {};
  int _currentReadingId = 0;
  RxInt negativeCount=0.obs;


    late ReadingRepository readingRepository ; // Fetch instance
    late ReadingCountRepository readingCountRepository ; // Fetch instance


  @override
  void onInit() {
    super.onInit();
    _loadData();
  }
  _loadData() async{
    readingRepository = await  Get.find<ReadingRepository>();
    readingCountRepository = await  Get.find<ReadingCountRepository>();
    getAllReadingData();
    getNegativeCount();
  }
  // 00000000000000000000000000000000000000000000000000000000000000000000
  List<String> availablePorts = [];
  SerialPort? port;
  SerialPortReader? reader;
  String receivedData = "No data received";

  Future<void> listAvailablePorts() async {
    availablePorts = SerialPort.availablePorts;
    print('🔍 Available Ports: $availablePorts');

    if (availablePorts.isNotEmpty) {
      String selectedPort = availablePorts.first;
      print("🔄 Using Port: $selectedPort");
      openPort(selectedPort);
    } else {
      print("⚠️ No serial ports detected!");
    }
  }

  void openPort(String portName) async {
   await disconnect(); // Close existing port before opening a new one

    port = SerialPort(portName);
    if (!port!.openReadWrite()) {
      return;
    }
    // Configure serial port
    final config = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..parity = SerialPortParity.none
      ..stopBits = 1;
    port!.config = config;
    await SharedPrefHelper.saveBool(SharedPrefKeys.isConnect, true);
    // Delay before reading data (fixes issue after restart)
    await Future.delayed(Duration(seconds: 2));

    startReading();
  }

  void startReading() {
    print("📡 Listening for data...");
    String _buffer = '';
    String currentReading='';
    int readingId=0;
    reader = SerialPortReader(port!);
    reader!.stream.listen((data) async {
      String newData = String.fromCharCodes(data).trim();
      if (newData.isNotEmpty) {
        String receivedData = String.fromCharCodes(data);
        _dataController.add(receivedData); // Send data to stream
        _buffer += receivedData;
        print("_buffer0 $_buffer");
        if(_buffer.startsWith("*") && _buffer.length == 20){
          currentReading=_buffer;
          readingId= await parseRawData(_buffer);
          print("_buffer1 $_buffer");
          _currentReadingId=readingId;
          print("_currentReadingId $_currentReadingId");
          _buffer='';
        }
        _debounceTimer1?.cancel();
        _debounceTimer1 = Timer(Duration(milliseconds: 200), () async {
          RegExp regex = RegExp(r"[$#](?:\](\d+)|(\d+))"); // Updated regex
          Iterable<Match> matches = regex.allMatches(_buffer);
          print("_buffer $_buffer");
          for (Match match in matches) {
            String? positiveValue = match.group(2); // Normal positive values
            String? negativeValue = match.group(1); // Values from `#]`

            String counterValue = negativeValue != null ? "-$negativeValue" : positiveValue!;

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
              getAllReadingData();
            }
          }
          _buffer = '';
        });


      } else {
        print("⚠️ Received Empty Data!");
      }
    }, onError: (error) {
      print('❌ Serial Error: $error');
      print("🔄 Restarting Serial Connection...");
      //restartSerialPort();
    });
  }


  // 000000000000000000000000000000000000000000000000000000

  Future<void> disconnect() async {
    if (port != null && port!.isOpen) {
      port!.close();
      port = null;
    }
    await SharedPrefHelper.saveBool(SharedPrefKeys.isConnect, false);
    isConnected = false;
    _dataSubscription?.cancel();
    _dataSubscription = null;
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
      int allottedBag = (int.parse(dataPart.substring(15, 18))); // allowted bag
      print("allowted_baf: ${allottedBag}");


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
       ton: ton,
         allottedBag:allottedBag
     );

      print("allowted_baf2: ${reading.toString()}");
    var id =await readingRepository.insertReading(reading);


      var readingCount = ReadingCount(
        count: allottedBag.toString(),
        readingId: id,
        timestamp: DateTime.now().toIso8601String(),
      );
      var hash = await readingCountRepository.insertReadingCount(readingCount);
      print("hash* $hash");
      _lastCounts[_currentReadingId] = allottedBag.toString();
      getAllReadingData();
     return id;
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

  getAllReadingWithFilter(
  {DateTime? startDate,
      DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
      String? brand,
      String? bay,}
      ) async{
    List<ReadingWithCount> readingsWithC=  await readingRepository.getAllReadingsWithFilter(
      startTime: startTime,startDate: startDate,endTime:endTime,endDate: endDate,brand: brand,bay: bay
    );
    for(ReadingWithCount read1 in readingsWithC){
      print("read1.count ${read1.count}");
    }
   readingWithCountList.assignAll(readingsWithC.reversed);
    readingWithCountList.refresh();
  }


  getAllReadingData() async {
try {
  List<ReadingWithCount> readingsWithC = await readingRepository
      .getCombinedReadings();
  for(ReadingWithCount read1 in readingsWithC){
    // print("read1.count ${read1.count}");
  }
  readingWithCountList.assignAll(readingsWithC.reversed);
  readingWithCountList.refresh();
}catch(e){
  print("error : $e");
}
  }


  getNegativeCount() async {
    await readingCountRepository
        .getNegativeValues();
    negativeCount.value= await readingCountRepository.printNegativeValues();


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
