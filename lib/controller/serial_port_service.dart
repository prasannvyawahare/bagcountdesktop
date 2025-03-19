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

class SerialPortService extends GetxController {

  static SerialPortService get instance => Get.find();
  RxList<ReadingWithCount> readingWithCountList = <ReadingWithCount>[].obs;
  RxList<Reading> readingList = <Reading>[].obs;
  RxList<Reading> dayReadingList = <Reading>[].obs;
  final StreamController<String> _dataController = StreamController<String>.broadcast();
  bool isConnected = false;
  StreamSubscription? _dataSubscription;
  Stream<String> get dataStream => _dataController.stream;
  String newCount = '';
  Timer? _debounceTimer1;
  final Map<int, String> _lastCounts = {};
  int _currentReadingId = 0;
  RxString negativeCount = "".obs;
  RxString totalCount = "".obs;
  RxString brandTotalCount = "".obs;
  RxString truckTotalCount = "".obs;

  late ReadingRepository readingRepository; // Fetch instance
  late ReadingCountRepository readingCountRepository; // Fetch instance

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  _loadData() async {
    readingRepository = await Get.find<ReadingRepository>();
    readingCountRepository = await Get.find<ReadingCountRepository>();
    getAllReadingData();
  }

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
    String _buffer = '';
    String currentReading = '';
    int readingId = 0;
    reader = SerialPortReader(port!);
    reader!.stream.listen((data) async {
      String newData = String.fromCharCodes(data).trim();
      if (newData.isNotEmpty) {
        String receivedData = String.fromCharCodes(data);
        _dataController.add(receivedData); // Send data to stream
        _buffer += receivedData;

        if (_buffer.startsWith("*") && _buffer.length == 20) {
          currentReading = _buffer;
          readingId = await parseRawData(_buffer);
          _currentReadingId = readingId;
          _buffer = '';
        }
        _debounceTimer1?.cancel();

        _debounceTimer1 = Timer(Duration(milliseconds: 200), () async {
          RegExp regex = RegExp(r"[$#](?:\](\d+)|(\d+))"); // Updated regex
          Iterable<Match> matches = regex.allMatches(_buffer);

          for (Match match in matches) {
            String? positiveValue = match.group(2); // Normal positive values
            String? negativeValue = match.group(1); // Values from `#]`
            String counterValue =
                negativeValue != null ? "-$negativeValue" : positiveValue!;

            if (_currentReadingId == 0) continue;

            if (_lastCounts[_currentReadingId] != counterValue) {
              final timestamp = DateTime.now().toIso8601String();
              final time = timestamp.split('T')[1].substring(0, 5);
              var hash = await readingRepository.updateCurrentCount(
                  id: _currentReadingId, newCount: counterValue, endTime: time);
              print("hash* $hash");
              _lastCounts[_currentReadingId] = counterValue;
              getAllReadingData();
            }
          }
          _buffer = '';
        });
      }
    }, onError: (error) {
      //restartSerialPort();
    });
  }

  Future<void> disconnect() async {
    if (port != null && port!.isOpen) {
      port!.close();
      port = null;
    }
    await SharedPrefHelper.saveBool(SharedPrefKeys.isConnect, false);
    var isConnect = await SharedPrefHelper.getBool(SharedPrefKeys.isConnect) ?? false;
    print(isConnect) ;
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
      String counterStatus =
          parts.length > 1 ? parts[1] : ""; // Counter status before #

      // Extract values
      String bay = dataPart.substring(0, 2); // First 2 digits = Bay
      String truckNo = dataPart.substring(2, 6); // Next 4 digits = Truck No.
      String brand = dataPart.substring(6, 9); // Next 3 characters = Brand
      double mrp =
          double.parse(dataPart.substring(9, 12)); // Next 3 digits = MRP
      double ton = (int.parse(dataPart.substring(12, 15)) / 10)
          .toDouble(); // Next 3 digits = Ton (divided by 10)
      int allottedBag = (int.parse(dataPart.substring(15, 18))); // allowted bag
      print("allowted_baf: ${allottedBag}");

      if (bay == '10') {
        bay = "01";
      } else {
        bay = "02";
      }

      final timestamp = DateTime.now().toIso8601String();
      final date = timestamp.split('T')[0];
      final time = timestamp.split('T')[1].substring(0, 5);

      final reading = Reading(
          timestamp: date,
          startTime: time,
          endTime: time,
          bay: bay,
          truckNo: truckNo,
          brand: brand,
          mrp: mrp,
          ton: ton,
          allottedBag: allottedBag.toString(),
          currentCount: allottedBag.toString());

      var id = await readingRepository.insertReading(reading);
      _lastCounts[_currentReadingId] = allottedBag.toString();
      getAllReadingData();
      return id;
    } catch (e) {
      throw Exception('Error parsing data: $e');
    }
  }

  getAllReadingWithFilter({
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? brand,
    String? bay,
  }) async {
    List<Reading> readingsWithC =
        await readingRepository.getFilteredReadings(
            startTime: startTime,
            startDate: startDate,
            endTime: endTime,
            endDate: endDate,
            brand: brand,
            bay: bay);

    readingList.assignAll(readingsWithC.reversed);
    readingList.refresh();
  }

  getAllReadingData() async {
    try {
      List<Reading> readings = await readingRepository.getReadings();
      readingList.assignAll(readings.reversed);
      readingList.refresh();


      final timestamp = DateTime.now().toIso8601String();
      final date = timestamp.split('T')[0];
      getDayWiseReading(date);
    } catch (e) {
      print("error : $e");
    }
    final timestamp = DateTime.now().toIso8601String();
    final date = timestamp.split('T')[0];
    getNegativeCount(date);
    getTotalTon(date);
  }


  getNegativeCount(String date) async {

    var count = await readingRepository.getNegativeCurrentCountForDate(date);
    negativeCount.value= count.toString();
    print("negativeCount $count");
  }

  getTotalTon(String date) async {
    var count = await readingRepository.getTotalWeightForDate(date);
    totalCount.value=count.toStringAsFixed(2);
  }

  void closeDb() async {
    await readingRepository.closeDb();
  }

  searchReadingData(String search) async {
    List<Reading> readings = await readingRepository.searchReading(search);
    readingList.assignAll(readings.reversed);
    readingList.refresh();
    dayReadingList.refresh();
  }
  getAllBrandCount(String date) async {

    var count=  await readingRepository.getTotalDifferentBrandCountByDate(date);
    brandTotalCount.value=count.toString();
    brandTotalCount.refresh();
    dayReadingList.refresh();
  }

  getAllTruckCount(String date) async {
    var count=  await readingRepository.getTotalDifferentTruckCountByDate(date);
    truckTotalCount.value=count.toString();
    truckTotalCount.refresh();
    dayReadingList.refresh();
  }
  getDayWiseReading(String day)async{

    List<Reading> readings =  await readingRepository. getTodayReadings(day);
    if(readings.length>0){
      dayReadingList.assignAll(readings.reversed);
      dayReadingList.refresh();
      getTotalTon(day);
      getNegativeCount(day);
      getAllBrandCount(day);
      getAllTruckCount(day);
    }else{
      totalCount.value=0.toString();
      negativeCount.value=0.toString();
      brandTotalCount.value=0.toString();
      truckTotalCount.value=0.toString();
      dayReadingList.clear();
      dayReadingList.refresh();
    }


  }


  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    super.dispose();
    try {
      _dataController.close();
      _dataSubscription?.cancel();
      await disconnect();

    } catch (e) {
      print("error : $e");
    }
  }
}
