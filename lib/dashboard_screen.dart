import 'package:bagreportun/repository/product_repository.dart';
import 'package:bagreportun/repository/reading_count_repository.dart';
import 'package:bagreportun/repository/reading_repository.dart';
import 'package:bagreportun/repository/shift_repository.dart';
import 'package:bagreportun/util/constant_string.dart';
import 'package:bagreportun/util/shared_pref_helper.dart';
import 'package:bagreportun/vew_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/serial_port_service.dart';
import 'model/product.dart';
import 'model/reading_with_count.dart';
import 'model/shift.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = SerialPortService.instance;
  ReadingRepository readingRepository = ReadingRepository(); // Fetch instance
  final ProductRepository _productRepository = ProductRepository();
  late AnimationController _controller;
  late Animation<double> _animation;
  final ReadingCountRepository _readingCountRepository =
      ReadingCountRepository();
  final ShiftRepository _shiftRepository = ShiftRepository();
  int selectedIndex = 0;
  String bay = '',
      truckNo = '',
      rate = '',
      count = '',
      shiftLengthCount = '0',
      brandLengthCount = '0';
  bool isConnect = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchAvailablePorts();
      init();
      _loadProducts();
      _loadShifts();
      getDataFromDb();
      getDashboardData();
    });
  }


  Future<void> _fetchAvailablePorts() async {
    List<String> ports = SerialPort.availablePorts;
    print("🔍 Available Ports: ${ports.length}");
    if(ports.length == 0){
      await SharedPrefHelper.saveBool(SharedPrefKeys.isConnect, false);
      isConnect = false;
      if (mounted) setState(() {});
    }
  }


  getDataFromDb() async {
    await controller.getAllReadingData();
    setState(() {});
  }

  getDashboardData() async {
    setState(() {
      final timestamp = DateTime.now().toIso8601String();
      final date = timestamp.split('T')[0];
      controller.getDayWiseReading(date);
    });

  }

  Future<void> _loadShifts() async {
    List<Shift> _shiftList = await _shiftRepository.getAllShifts();
    shiftLengthCount = _shiftList.length.toString();
    print("shiftLengthCount $shiftLengthCount");
    setState(() {}); // Refresh the UI to display the loaded shifts
  }

  Future<void> _loadProducts() async {
    List<Product> _productList = await _productRepository.getAllProducts();
    brandLengthCount = _productList.length.toString();
    setState(() {}); // Refresh the UI to display the loaded products
  }

  Future<void> init() async {
    isConnect =
        await SharedPrefHelper.getBool(SharedPrefKeys.isConnect) ?? false;
    print(isConnect);
    if (mounted) {
      setState(() {
        controller.getAllReadingData();

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           SizedBox(height: 10,),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,),
              margin: EdgeInsets.symmetric(horizontal: 20, ),
              child: Center(
                child: Column(
                  children: [
                  Text(
                  'Bag Counter System',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                    Text(
                      "RCCPL Pvt. Ltd. Butibori (GU)",
                      style: TextStyle(fontSize: 14, color: Colors.blueAccent[100], fontWeight: FontWeight.bold),
                    ),


                  ],
                ),
              ),
            ),

          SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 20,),
                buildSelectableItem(0, "Today's Data"),
                SizedBox(width: 10),
                buildSelectableItem(1, "LastDay's Data"),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.only(left: 20, top: 10,bottom: 10),
                      child: Stack(
                        children: [
                          // Background SVG Image in the Right Corner
                          Align(
                            alignment: Alignment.center,
                            // Position at the bottom right
                            child: SvgPicture.asset(
                              'images/icons/one_drive.svg',
                              color: Colors
                                  .blue[100], // Replace with your actual SVG path
                              width: 120, // Adjust width as needed
                              height: 80, // Adjust height as needed
                            ),
                          ),

                          // Foreground Content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      width: 3, height: 20, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text(
                                    "Port Status",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(), // Pushes "Connect" text to the bottom
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    isConnect == true ? "Connect" : "Disconnect",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.only(left: 20, top: 10,bottom: 10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          // Position at the bottom right
                          child: SvgPicture.asset(
                            'images/icons/pdf_file.svg',
                            color: Colors.deepPurple[
                                100], // Replace with your actual SVG path
                            width: 100, // Adjust width as needed
                            height: 80, // Adjust height as needed
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 20,
                                  color: Colors.deepPurple,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Brand Available",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Spacer(), // Pushes "Connect" text to the bottom
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Obx(()=>   Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  controller. brandTotalCount.value,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                ),
                              ),),

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin:EdgeInsets.only(left: 20, top: 10,bottom: 10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          // Position at the bottom right
                          child: Image.asset(
                            'images/Truck.png',
                            color: Colors.yellow[
                                200], // Replace with your actual SVG path
                            width: 130, // Adjust width as needed
                            height: 80, // Adjust height as needed
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 20,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Total Truck",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Spacer(), // Pushes "Connect" text to the bottom
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Obx(
                                  ()=> Text(
                                    controller.truckTotalCount.value,
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.only(left: 20, top: 10,bottom: 10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          // Position at the bottom right
                          child: Image.asset(
                            'images/cement_bag_img.png',
                            color: Colors
                                .green[100], // Replace with your actual SVG path
                            width: 100, // Adjust width as needed
                            height: 80, // Adjust height as needed
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 20,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Total Extra Bag",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Spacer(), // Pushes "Connect" text to the bottom
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Obx(() => Text(
                                      controller.negativeCount.value.toString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 220,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin:EdgeInsets.only(left: 20, top: 10,bottom: 10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          // Position at the bottom right
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Image.asset(
                              'images/load.png',
                              color: Colors
                                  .brown[100], // Replace with your actual SVG path
                              width: 100, // Adjust width as needed
                              height: 70, // Adjust height as needed
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 20,
                                  color: Colors.brown,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Total Weight",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Spacer(), // Pushes "Connect" text to the bottom
                            Obx(() => Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Text(
                                      controller.totalCount.value.toString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: controller.dayReadingList.isNotEmpty && controller.dayReadingList.first.startTime.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => _buildParameterRow(
                                        'Bay', controller.dayReadingList.isNotEmpty ? controller.dayReadingList.first.bay : 'N/A')),
                                    Obx(() => _buildParameterRow(
                                        'Track No', controller.dayReadingList.isNotEmpty ? controller.dayReadingList.first.truckNo : 'N/A')),
                                    Obx(() => _buildParameterRow(
                                        'Brand', controller.dayReadingList.isNotEmpty ? controller.dayReadingList.first.brand.toString() : 'N/A')),
                                    Obx(() => _buildParameterRow(
                                        'Rate', controller.dayReadingList.isNotEmpty ? controller.dayReadingList.first.mrp.toString() : 'N/A')),
                                    Obx(() => _buildParameterRow(
                                        'Allotted Bag/Matrix Ton', controller.dayReadingList.isNotEmpty ? controller.dayReadingList.first.allottedBag.toString()+" / "+controller.dayReadingList.first.ton.toString() : 'N/A')),
                                    Obx(() => _buildParameterRow(
                                        'Remaining Bag',
                                        controller.dayReadingList.isNotEmpty && int.parse(controller.dayReadingList.first.currentCount) <= 0
                                            ? "0"
                                            : controller.dayReadingList.isNotEmpty
                                            ? controller.dayReadingList.first.currentCount
                                            : 'N/A')),
                                    Obx(() => controller.dayReadingList.isNotEmpty && controller.dayReadingList.first.currentCount.isNotEmpty
                                        ? _buildParameterRow(
                                        'Extra Bag',
                                        int.parse(controller.dayReadingList.first.currentCount) < 0
                                            ? controller.dayReadingList.first.currentCount
                                            : '0')
                                        : const SizedBox()),
                                  ],
                                )
                              : Center(
                                  child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: Offset(
                                                  2, 0), // Shadow to the right
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                            'images/no_data_img.png',
                                            width: 200,
                                            height: 200)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("No Data Available"),
                                  ],
                                ))),
                      Expanded(
                          child: Image.asset(
                        "images/truck_img.jpg",
                       // height: 200,
                        fit: BoxFit.fitHeight,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
          ),
          Text(":"),
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                 //color:Color(0xFFFC1300),
                 color:Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
    if(index == 0) {
      getDashboardData();
    }else{
      final timestamp = DateTime.now().subtract(Duration(days: 1)).toIso8601String();
      final lastDay = timestamp.split('T')[0]; // Extracts YYYY-MM-DD format
      controller.getDayWiseReading(lastDay);
    }


  }
  Widget buildSelectableItem(int index, String text) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onSelect(index),
      splashColor: Colors.blue.withOpacity(0.3), // Ripple color
      highlightColor: Colors.blue.withOpacity(0.1), // Pressed color
      borderRadius: BorderRadius.circular(10),
      child: Material(
       color: isSelected ? Colors.blue : Colors.white70,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

}

// Usage: Call WiBagCounter() widget in your app
