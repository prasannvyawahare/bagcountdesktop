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
import 'package:intl/intl.dart';

import 'controller/serial_port_service.dart';
import 'model/product.dart';
import 'model/reading_with_count.dart';
import 'model/shift.dart';

class HistoryScrenn extends StatefulWidget {
  const HistoryScrenn({super.key});

  @override
  State<HistoryScrenn> createState() => _HistoryScrennState();
}

class _HistoryScrennState extends State<HistoryScrenn> {
  final controller = SerialPortService.instance;
  ReadingRepository readingRepository = ReadingRepository();
  int selectedIndex = 0;
  String bay = '',
      truckNo = '',
      rate = '',
      count = '';
  String _oldDate="Calender";
  bool isConnect = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchAvailablePorts();
      init();
      getDataFromDb();
      getDashboardData();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 2)), // Start selection from 2 days ago
      firstDate: DateTime(1900, 1, 1), // Allow all past dates
      lastDate: DateTime.now().subtract(Duration(days: 2)), // Only up to 2 days ago
    );

    if (pickedDate != null) {
      setState(() {
          final timestamp =
          pickedDate.toIso8601String();
          final lastDay = timestamp.split('T')[0]; // Extracts YYYY-MM-DD format
          _oldDate=lastDay;
          controller.getDayWiseReading(lastDay);
      });
    }
  }


  Future<void> _fetchAvailablePorts() async {
    List<String> ports = SerialPort.availablePorts;
    print("🔍 Available Ports: ${ports.length}");
    if (ports.length == 0) {
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


  Future<void> init() async {
    isConnect =
        await SharedPrefHelper.getBool(SharedPrefKeys.isConnect) ?? false;
    print(isConnect);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        margin: EdgeInsets.all( 20),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                buildSelectableItem(0, "Today's Data"),
                SizedBox(width: 10),
                buildSelectableItem(1, "LastDay's Data"),
                SizedBox(width: 10),
                buildSelectableItem(2, "Calender"),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 200,
                    height: 100,
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
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                controller.brandTotalCount.value,
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              )),
                          Text(
                            "Brand Available",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      width: 200,
                      height: 100,
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
                      padding: EdgeInsets.symmetric(vertical: 5),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  controller.truckTotalCount.value,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                )),
                            Text(
                              "Total Truck",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Expanded(
                  child: Container(
                      width: 200,
                      height: 100,
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
                      padding: EdgeInsets.symmetric(vertical: 5),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  controller.negativeCount.value,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                )),
                            Text(
                              "Total Extra Bag",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Expanded(
                  child: Container(
                      width: 200,
                      height: 100,
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
                      padding: EdgeInsets.symmetric(vertical: 5),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  controller.totalCount.value,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                )),
                            Text(
                              "Total Weight",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              if (controller.dayReadingList.isEmpty) {
                return Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(2, 0), // Shadow to the right
                            ),
                          ],
                        ),
                        child: Image.asset('images/no_data_img.png', width: 200, height: 200)),

                    SizedBox(height: 10,),


                    Text("No data available",
                        style:
                        TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ));
              }
              return Expanded(
                child: SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Rounded corners for the DataTable
                    child: PaginatedDataTable(
                      columnSpacing: 10, // Adjust this value as needed
                      columns: const [
                        DataColumn(label: Text('Bay')),
                        DataColumn(label: Text('Brand')),
                        DataColumn(label: Text('Ton')),
                        DataColumn(label: Text('MRP')),
                        DataColumn(label: Text('Truck\nNo.')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Start\nTime')),
                        DataColumn(label: Text('End\nTime')),
                        DataColumn(label: Text('Allotted\nBags')),
                        DataColumn(label: Text('Remain\nBags')),
                        DataColumn(label: Text('Extra\nBags')),
                      ],
                      source: ReadingDataTableSourceTwo(),
                      rowsPerPage: controller.dayReadingList.length < 10
                          ? controller.dayReadingList.length
                          : 8, // Number of rows per page
                    ),
                  ),
                ),
              );
            })

          ],
        ),
      ),
    );
  }

  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      _oldDate="Calender";
      getDashboardData();
    } else  if (index == 1) {
      _oldDate="Calender";
      final timestamp =
          DateTime.now().subtract(Duration(days: 1)).toIso8601String();
      final lastDay = timestamp.split('T')[0]; // Extracts YYYY-MM-DD format
      controller.getDayWiseReading(lastDay);
    }else{
      _selectDate(context);
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
class ReadingDataTableSourceTwo extends DataTableSource {

  final controller = SerialPortService.instance;

  @override
  DataRow? getRow(int index) {
    if (index >= controller.dayReadingList.length) return null;
    final truckData = controller.dayReadingList[index];

    return DataRow(
        color: MaterialStateColor.resolveWith((states) => Colors.white),
        cells: [
          DataCell(Text(truckData.bay)),  //bat
          DataCell(Text(truckData.brand)), //brand
          DataCell(Text(truckData.ton.toString())), //ton
          DataCell(Text(truckData.mrp.toString())), //mrp
          DataCell(Text(truckData.truckNo.toString())), //truckNo
          DataCell(Text(getDate(truckData.timestamp))),
          DataCell(Text(truckData.startTime)),
          DataCell(Text(truckData.endTime)),
          DataCell(Text(truckData.allottedBag.toString())),
          int.parse(truckData.currentCount ) <=0? DataCell(Text('0')):
          DataCell(Text(truckData.currentCount.toString())),
          int.parse(truckData.currentCount)<0?
          DataCell(Text(  truckData.currentCount.toString())):DataCell(Text('0')),

        ]);
  }

  @override
  int get rowCount =>  controller.dayReadingList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  String getDate(String time) {
    DateTime dateTime = DateTime.parse(time);
    String formattedDate = DateFormat('dd/MM/yy').format(dateTime);
    return formattedDate;
  }

}