import 'package:bagreportun/repository/product_repository.dart';
import 'package:bagreportun/repository/reading_repository.dart';
import 'package:bagreportun/repository/shift_repository.dart';
import 'package:bagreportun/util/generate_exl.dart';
import 'package:bagreportun/util/generate_pdf.dart';
import 'package:bagreportun/util/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import 'controller/serial_port_service.dart';
import 'model/product.dart';
import 'model/reading.dart';
import 'model/reading_with_count.dart';
import 'model/shift.dart';

class VewReportScreen extends StatefulWidget {
  const VewReportScreen({super.key});

  @override
  State<VewReportScreen> createState() => _VewReportScreenState();
}

class _VewReportScreenState extends State<VewReportScreen> {
  final controller = SerialPortService.instance;
  final ProductRepository _productRepository = ProductRepository();
  final ShiftRepository _shiftRepository = ShiftRepository();
   List<Product> _productList=[];
  List<Shift> _shiftList=[];
  Product? _selectedProduct;
  List<String> _listbay = ["01","02"];
  Shift? _selectedShift;
  String? _selectedBay;
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  bool _isAddFilterExpanded = false;
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = pickedDate;
        } else {
          _toDate = pickedDate;
        }
      });
    }
  }
  Future<void> _selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isFromTime) {
          _fromTime = pickedTime;
        } else {
          _toTime = pickedTime;
        }
      });
    }
  }

  _getFilteredData(
      DateTime? _startDate,
      DateTime? _endDate,
      TimeOfDay? _startTime,
      TimeOfDay? _endTime,
      String? _brand,
      String? _bay,
      ) async {
  await controller.getAllReadingWithFilter(
      startDate: _startDate,
      endDate: _endDate,
      startTime: _startTime,
      endTime: _endTime,
      brand: _brand,
      bay: _bay,
    );

  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _loadProducts();
    _loadShifts();
    controller.getAllReadingData();

  }

  void _loadProducts() async {
    _productList = await _productRepository.getAllProducts();
    setState(() {});
  }
  void _loadShifts() async{
    _shiftList = await _shiftRepository.getAllShifts();

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter Section
              ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isAddFilterExpanded = !_isAddFilterExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: _isAddFilterExpanded,
                    headerBuilder: (context, isExpanded) {
                      return const ListTile(
                        title: Text(
                          "Add Filter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:  Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                    Border.all(color: Colors.grey[300]!, width: 1),
                                    color: Colors.white,
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Row 1: Input Fields
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text("From Date",
                                                    style:
                                                    TextStyle(color: Colors.black54)),
                                                SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () => _selectDate(context, true),
                                                  child: Container(
                                                    width: 120,
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 8, horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      border:
                                                      Border.all(color: Colors.grey),
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      _fromDate != null
                                                          ? "${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}"
                                                          : "DD/MM/YYYY",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text("TO Date",
                                                    style:
                                                    TextStyle(color: Colors.black54)),
                                                SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () =>
                                                      _selectDate(context, false),
                                                  child: Container(
                                                    width: 120,
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 8, horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      border:
                                                      Border.all(color: Colors.grey),
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      _toDate != null
                                                          ? "${_toDate!.day}/${_toDate!.month}/${_toDate!.year}"
                                                          : "DD/MM/YYYY",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text("From Time",
                                                    style:
                                                    TextStyle(color: Colors.black54)),
                                                SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () => _selectTime(context, true),
                                                  child: Container(
                                                    width: 120,
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 8, horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      border:
                                                      Border.all(color: Colors.grey),
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      _fromTime != null
                                                          ? "${_fromTime!.hour}:${_fromTime!.minute.toString().padLeft(2, '0')}"
                                                          : "HH:MM",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text("To Time",
                                                    style:
                                                    TextStyle(color: Colors.black54)),
                                                SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () =>
                                                      _selectTime(context, false),
                                                  child: Container(
                                                    width: 120,
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 8, horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      border:
                                                      Border.all(color: Colors.grey),
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      _toTime != null
                                                          ? "${_toTime!.hour}:${_toTime!.minute.toString().padLeft(2, '0')}"
                                                          : "HH:MM",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                // Title for the dropdown
                                                Text("Brand",
                                                    style:
                                                    TextStyle(color: Colors.black54)),
                                                SizedBox(height: 8),
                                                // Dropdown for selecting a map
                                                Container(
                                                  height: 35,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    border:
                                                    Border.all(color: Colors.grey),
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                  ),
                                                  child: DropdownButton<Product>(
                                                    value: _selectedProduct,
                                                    isExpanded: true,
                                                    underline: SizedBox(),
                                                    items: _productList.map<DropdownMenuItem<Product>>((Product product) {
                                                      return DropdownMenuItem<Product>(
                                                        value: product,
                                                        child: Text(
                                                          product.name,
                                                          style: TextStyle(
                                                            color: Colors.black45,
                                                            fontSize: 12,
                                                            decoration: TextDecoration.none,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (Product? newValue) {
                                                      setState(() {
                                                        _selectedProduct = newValue; // Update the selected value
                                                      });
                                                    },
                                                    hint: Text(
                                                      "Select",
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 12,
                                                        decoration: TextDecoration.none, // Ensures no line appears
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                // Title for the dropdown
                                                Text("Bay",
                                                    style:
                                                    TextStyle(color: Colors.black54)),
                                                SizedBox(height: 8),
                                                // Dropdown for selecting a map
                                                Container(
                                                  height: 35,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    border:
                                                    Border.all(color: Colors.grey),
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                  ),
                                                  child: DropdownButton<String>(
                                                    value:
                                                    _selectedBay, // Currently selected value
                                                    isExpanded:
                                                    true, // Makes the dropdown take full width
                                                    underline:
                                                    SizedBox(), // Removes the default underline
                                                    items: _listbay
                                                        .map<DropdownMenuItem<String>>(
                                                            (String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: TextStyle(
                                                                  color: Colors.black45,
                                                                  fontSize: 12),
                                                            ),
                                                          );
                                                        }).toList(),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        _selectedBay =
                                                            newValue; // Update the selected value
                                                      });
                                                    },
                                                    hint: Text("Select",
                                                        style: TextStyle(
                                                            color: Colors.black45,
                                                            fontSize: 12)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      // Row 2: Radio Buttons and Apply Button
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // PDF option
                                              GestureDetector(
                                                onTap: () async {
                                                  // Handle PDF action
                                                 var path= await exportReadingsToPdf(controller.readingWithCountList);
                                                  //await OpenFilex.open(path);
                                                 FileAlert.showFileSavedDialog(context, path);
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.asset('images/pdf.png', width: 30, height: 30),
                                                    Text('PDF File', style: TextStyle(fontSize: 12)),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(width: 30), // Add some space between PDF and Excel

                                              // Excel option
                                              GestureDetector(
                                                onTap: () async {
                                                var filePath= await exportReadingsToExcel(controller.readingWithCountList);
                                                FileAlert.showFileSavedDialog(context, filePath);
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.asset('images/xls.png', width: 30, height: 30),
                                                    Text('Excel File', style: TextStyle(fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Container(
                                            width: 150,
                                            margin: EdgeInsets.only(right: 50),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _getFilteredData(_fromDate, _toDate,
                                                    _fromTime,
                                                    _toTime,
                                                    _selectedProduct?.brand.toString(),
                                                    _selectedBay);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24, vertical: 16),
                                              ),
                                              child: Text("Apply",
                                                  style: TextStyle(color: Colors.white)),

                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            margin: EdgeInsets.only(right: 50),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                controller.getAllReadingData();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24, vertical: 16),
                                              ),
                                              child: Text("Clear",
                                                  style: TextStyle(color: Colors.white)),

                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.readingWithCountList.isEmpty) {
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
                        columns: const [
                          DataColumn(label: Text('Bay')),
                          DataColumn(label: Text('Brand')),
                          DataColumn(label: Text('Ton')),
                          DataColumn(label: Text('MRP')),
                          DataColumn(label: Text('Truck No.')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('Allotted\nBags')),
                          DataColumn(label: Text('Remain\nBags')),
                          DataColumn(label: Text('Extra\nBags')),
                        ],
                        source: ReadingDataTableSource(),
                        rowsPerPage: controller.readingWithCountList.length < 10
                            ? controller.readingWithCountList.length
                            : 8, // Number of rows per page
                      ),
                    ),
                  ),
                );
              })


              //) ,
            ],
          ),
        ),
      ),
    );
  }
}


class ReadingDataTableSource extends DataTableSource {

  final controller = SerialPortService.instance;

  @override
  DataRow? getRow(int index) {
    if (index >= controller.readingWithCountList.length) return null;
    final truckData = controller.readingWithCountList[index];

    return DataRow(
        color: MaterialStateColor.resolveWith((states) => Colors.white),
        cells: [
      DataCell(Text(truckData.bay)),  //bat
      DataCell(Text(truckData.brand)), //brand
      DataCell(Text(truckData.ton.toString())), //ton
      DataCell(Text(truckData.mrp.toString())), //mrp
      DataCell(Text(truckData.truckNo.toString())), //truckNo
      DataCell(Text(getDate(truckData.timestamp))),
      DataCell(Text(getTime(truckData.readingCountTimestamp))),
      DataCell(Text(truckData.allottedBag.toString())),
      int.parse(truckData.count ) <=0? DataCell(Text('0')):
      DataCell(Text(truckData.count.toString())),
      int.parse(truckData.count)<0?
      DataCell(Text(  truckData.count.toString())):DataCell(Text('0')),

    ]);
  }

  @override
  int get rowCount =>  controller.readingWithCountList.length;

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
String getTime(String time) {
  DateTime dateTime = DateTime.parse(time);
  String formattedDate = DateFormat('HH:mm').format(dateTime);
  return formattedDate;
}




