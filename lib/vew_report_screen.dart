import 'package:bagreportun/repository/reading_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller/serial_port_service.dart';
import 'model/reading.dart';
import 'model/reading_with_count.dart';

class VewReportScreen extends StatefulWidget {
  const VewReportScreen({super.key});

  @override
  State<VewReportScreen> createState() => _VewReportScreenState();
}

class _VewReportScreenState extends State<VewReportScreen> {
  final controller = SerialPortService.instance;
  List<String> _mapList = [
    "All",
    "Google Maps",
    "Apple Maps",
    "Bing Maps",
    "OpenStreetMap"
  ];
  String? _selectedMap; // Variable to store the selected map
  List<String> _shiftList = ["All", "A", "B", "C", "D"];
  String? _selectedShift; // Variable to store the selected map
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    controller.getAllReadingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      // appBar: AppBar(
      //   title: const Text(
      //     "View Report",
      //     style: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.blue,
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.refresh, color: Colors.blue),
      //       onPressed: () {
      //         controller.getAllReadingData(); // Refresh data
      //       },
      //     ),
      //  IconButton(
      //       icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
      //       onPressed: () {
      //         controller.getAllReadingData(); // Refresh data
      //       },
      //     ),
      //   ],
      // ),
      body: Container(
       // color: Colors.white,
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
                                                  child: DropdownButton<String>(
                                                    value:
                                                    _selectedMap, // Currently selected value
                                                    isExpanded:
                                                    true, // Makes the dropdown take full width
                                                    underline:
                                                    SizedBox(), // Removes the default underline
                                                    items: _mapList
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
                                                        _selectedMap =
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
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                // Title for the dropdown
                                                Text("Shift",
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
                                                    _selectedShift, // Currently selected value
                                                    isExpanded:
                                                    true, // Makes the dropdown take full width
                                                    underline:
                                                    SizedBox(), // Removes the default underline
                                                    items: _shiftList
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
                                                        _selectedShift =
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
                                            children: [
                                              Radio(
                                                  value: true,
                                                  groupValue: true,
                                                  onChanged: (val) {}),
                                              Text('Hourly'),
                                              SizedBox(width: 16),
                                              Radio(
                                                  value: false,
                                                  groupValue: true,
                                                  onChanged: (val) {}),
                                              Text('Shift-wise'),
                                              SizedBox(width: 16),
                                              Radio(
                                                  value: false,
                                                  groupValue: true,
                                                  onChanged: (val) {}),
                                              Text('Day-wise'),
                                            ],
                                          ),
                                          Spacer(),
                                          Container(
                                            width: 150,
                                            margin: EdgeInsets.only(right: 50),
                                            child: ElevatedButton(
                                              onPressed: () {},
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


              // Row(
              //   children: [
              //     Expanded(
              //       child: Center(
              //         child: Container(
              //           padding: EdgeInsets.all(16),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(12),
              //             border:
              //             Border.all(color: Colors.grey[300]!, width: 1),
              //             color: Colors.white,
              //           ),
              //           width: MediaQuery.of(context).size.width * 0.9,
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.stretch,
              //             children: [
              //               // Row 1: Input Fields
              //               Row(
              //                 children: [
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       children: [
              //                         Text("From Date",
              //                             style:
              //                             TextStyle(color: Colors.black54)),
              //                         SizedBox(height: 8),
              //                         GestureDetector(
              //                           onTap: () => _selectDate(context, true),
              //                           child: Container(
              //                             width: 120,
              //                             padding: EdgeInsets.symmetric(
              //                                 vertical: 8, horizontal: 8),
              //                             decoration: BoxDecoration(
              //                               border:
              //                               Border.all(color: Colors.grey),
              //                               borderRadius:
              //                               BorderRadius.circular(4),
              //                             ),
              //                             child: Text(
              //                               _fromDate != null
              //                                   ? "${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}"
              //                                   : "DD/MM/YYYY",
              //                               style: TextStyle(
              //                                   color: Colors.black45,
              //                                   fontSize: 12),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       children: [
              //                         Text("TO Date",
              //                             style:
              //                             TextStyle(color: Colors.black54)),
              //                         SizedBox(height: 8),
              //                         GestureDetector(
              //                           onTap: () =>
              //                               _selectDate(context, false),
              //                           child: Container(
              //                             width: 120,
              //                             padding: EdgeInsets.symmetric(
              //                                 vertical: 8, horizontal: 8),
              //                             decoration: BoxDecoration(
              //                               border:
              //                               Border.all(color: Colors.grey),
              //                               borderRadius:
              //                               BorderRadius.circular(4),
              //                             ),
              //                             child: Text(
              //                               _toDate != null
              //                                   ? "${_toDate!.day}/${_toDate!.month}/${_toDate!.year}"
              //                                   : "DD/MM/YYYY",
              //                               style: TextStyle(
              //                                   color: Colors.black45,
              //                                   fontSize: 12),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       children: [
              //                         Text("From Time",
              //                             style:
              //                             TextStyle(color: Colors.black54)),
              //                         SizedBox(height: 8),
              //                         GestureDetector(
              //                           onTap: () => _selectTime(context, true),
              //                           child: Container(
              //                             width: 120,
              //                             padding: EdgeInsets.symmetric(
              //                                 vertical: 8, horizontal: 8),
              //                             decoration: BoxDecoration(
              //                               border:
              //                               Border.all(color: Colors.grey),
              //                               borderRadius:
              //                               BorderRadius.circular(4),
              //                             ),
              //                             child: Text(
              //                               _fromTime != null
              //                                   ? "${_fromTime!.hour}:${_fromTime!.minute.toString().padLeft(2, '0')}"
              //                                   : "HH:MM",
              //                               style: TextStyle(
              //                                   color: Colors.black45,
              //                                   fontSize: 12),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       children: [
              //                         Text("To Time",
              //                             style:
              //                             TextStyle(color: Colors.black54)),
              //                         SizedBox(height: 8),
              //                         GestureDetector(
              //                           onTap: () =>
              //                               _selectTime(context, false),
              //                           child: Container(
              //                             width: 120,
              //                             padding: EdgeInsets.symmetric(
              //                                 vertical: 8, horizontal: 8),
              //                             decoration: BoxDecoration(
              //                               border:
              //                               Border.all(color: Colors.grey),
              //                               borderRadius:
              //                               BorderRadius.circular(4),
              //                             ),
              //                             child: Text(
              //                               _toTime != null
              //                                   ? "${_toTime!.hour}:${_toTime!.minute.toString().padLeft(2, '0')}"
              //                                   : "HH:MM",
              //                               style: TextStyle(
              //                                   color: Colors.black45,
              //                                   fontSize: 12),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       children: [
              //                         // Title for the dropdown
              //                         Text("Brand",
              //                             style:
              //                             TextStyle(color: Colors.black54)),
              //                         SizedBox(height: 8),
              //                         // Dropdown for selecting a map
              //                         Container(
              //                           height: 35,
              //                           padding: EdgeInsets.symmetric(
              //                               vertical: 8, horizontal: 8),
              //                           decoration: BoxDecoration(
              //                             border:
              //                             Border.all(color: Colors.grey),
              //                             borderRadius:
              //                             BorderRadius.circular(4),
              //                           ),
              //                           child: DropdownButton<String>(
              //                             value:
              //                             _selectedMap, // Currently selected value
              //                             isExpanded:
              //                             true, // Makes the dropdown take full width
              //                             underline:
              //                             SizedBox(), // Removes the default underline
              //                             items: _mapList
              //                                 .map<DropdownMenuItem<String>>(
              //                                     (String value) {
              //                                   return DropdownMenuItem<String>(
              //                                     value: value,
              //                                     child: Text(
              //                                       value,
              //                                       style: TextStyle(
              //                                           color: Colors.black45,
              //                                           fontSize: 12),
              //                                     ),
              //                                   );
              //                                 }).toList(),
              //                             onChanged: (String? newValue) {
              //                               setState(() {
              //                                 _selectedMap =
              //                                     newValue; // Update the selected value
              //                               });
              //                             },
              //                             hint: Text("Select",
              //                                 style: TextStyle(
              //                                     color: Colors.black45,
              //                                     fontSize: 12)),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   SizedBox(width: 10),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       children: [
              //                         // Title for the dropdown
              //                         Text("Shift",
              //                             style:
              //                             TextStyle(color: Colors.black54)),
              //                         SizedBox(height: 8),
              //                         // Dropdown for selecting a map
              //                         Container(
              //                           height: 35,
              //                           padding: EdgeInsets.symmetric(
              //                               vertical: 8, horizontal: 8),
              //                           decoration: BoxDecoration(
              //                             border:
              //                             Border.all(color: Colors.grey),
              //                             borderRadius:
              //                             BorderRadius.circular(4),
              //                           ),
              //                           child: DropdownButton<String>(
              //                             value:
              //                             _selectedShift, // Currently selected value
              //                             isExpanded:
              //                             true, // Makes the dropdown take full width
              //                             underline:
              //                             SizedBox(), // Removes the default underline
              //                             items: _shiftList
              //                                 .map<DropdownMenuItem<String>>(
              //                                     (String value) {
              //                                   return DropdownMenuItem<String>(
              //                                     value: value,
              //                                     child: Text(
              //                                       value,
              //                                       style: TextStyle(
              //                                           color: Colors.black45,
              //                                           fontSize: 12),
              //                                     ),
              //                                   );
              //                                 }).toList(),
              //                             onChanged: (String? newValue) {
              //                               setState(() {
              //                                 _selectedShift =
              //                                     newValue; // Update the selected value
              //                               });
              //                             },
              //                             hint: Text("Select",
              //                                 style: TextStyle(
              //                                     color: Colors.black45,
              //                                     fontSize: 12)),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 20),
              //               // Row 2: Radio Buttons and Apply Button
              //               Row(
              //                 children: [
              //                   Row(
              //                     children: [
              //                       Radio(
              //                           value: true,
              //                           groupValue: true,
              //                           onChanged: (val) {}),
              //                       Text('Hourly'),
              //                       SizedBox(width: 16),
              //                       Radio(
              //                           value: false,
              //                           groupValue: true,
              //                           onChanged: (val) {}),
              //                       Text('Shift-wise'),
              //                       SizedBox(width: 16),
              //                       Radio(
              //                           value: false,
              //                           groupValue: true,
              //                           onChanged: (val) {}),
              //                       Text('Day-wise'),
              //                     ],
              //                   ),
              //                   Spacer(),
              //                   Container(
              //                     width: 150,
              //                     margin: EdgeInsets.only(right: 50),
              //                     child: ElevatedButton(
              //                       onPressed: () {},
              //                       style: ElevatedButton.styleFrom(
              //                         backgroundColor: Colors.blue,
              //                         shape: RoundedRectangleBorder(
              //                           borderRadius: BorderRadius.circular(8),
              //                         ),
              //                         padding: EdgeInsets.symmetric(
              //                             horizontal: 24, vertical: 16),
              //                       ),
              //                       child: Text("Apply",
              //                           style: TextStyle(color: Colors.white)),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              //....................
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         width: 150,
              //         child: ElevatedButton(
              //           onPressed: () {},
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.blue,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             padding: EdgeInsets.symmetric(
              //                 horizontal: 24, vertical: 16),
              //           ),
              //           child: Text("Excel Download",
              //               style: TextStyle(color: Colors.white)),
              //         ),
              //       ),
              //       SizedBox(width: 20),
              //       SizedBox(
              //         width: 150,
              //         child: ElevatedButton(
              //           onPressed: () {},
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.blue,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             padding: EdgeInsets.symmetric(
              //                 horizontal: 24, vertical: 16),
              //           ),
              //           child: Text("PDF Downloan",
              //               style: TextStyle(color: Colors.white)),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(height: 10),
              //show filter data
              // Row(
              //   children: [
              //     Row(
              //       children: [
              //         Text(
              //           "Date: ",
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: 16),
              //         ),
              //         Text(
              //           "02/07/2024",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //         Text(
              //           " To ",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //         Text(
              //           "02/07/2024",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //       ],
              //     ),
              //     SizedBox(width: 15),
              //     Row(
              //       children: [
              //         Text(
              //           "Time: ",
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: 16),
              //         ),
              //         Text(
              //           "00:00",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //         Text(
              //           " To ",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //         Text(
              //           "23:59",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //       ],
              //     ),
              //     SizedBox(width: 15),
              //     Row(
              //       children: [
              //         Text(
              //           "Brand: ",
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: 16),
              //         ),
              //         Text(
              //           "All",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //       ],
              //     ),
              //     SizedBox(width: 15),
              //     Row(
              //       children: [
              //         Text(
              //           "Shift: ",
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: 16),
              //         ),
              //         Text(
              //           "All",
              //           style: TextStyle(
              //             fontSize: 16,
              //           ),
              //         ),
              //       ],
              //     ),
              //     SizedBox(width: 15),
              //     Text(
              //       "Reset Filter",
              //       style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.red[700]),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
          Obx(()=>Expanded(
            child: SingleChildScrollView(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Rounded corners for the DataTable
                  child: PaginatedDataTable(
                    //  header: Text('Reading Data Table'),
                    // headingRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // White header background

                    columns: const [
                      DataColumn(label:Text('Bay'),),
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
                    rowsPerPage:  controller.readingWithCountList.length<10? controller.readingWithCountList.length:8, // Number of rows per page
                  )
                // child:  DataTable(
                //   headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade100), // Title row color
                //   dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Data row color
                //   //columnSpacing: 10,
                //   columnSpacing: 10,
                //   columns: const [
                //     DataColumn(label:Text('Bay'),),
                //     DataColumn(label: Text('Brand')),
                //     DataColumn(label: Text('Ton')),
                //     DataColumn(label: Text('MRP')),
                //     DataColumn(label: Text('Truck No.')),
                //     DataColumn(label: Text('Start Date')),
                //    DataColumn(label: Text('Time')),
                //     DataColumn(label: Text('Allotted\nBags')),
                //     DataColumn(label: Text('Remain\nBags')),
                //     DataColumn(label: Text('Extra\nBags')),
                //   ],
                //   rows: List.generate(
                //     controller.readingWithCountList.length,
                //         (index) => recentFileDataRow(controller.readingWithCountList[index]),
                //   ),
                //
                // ),

              ),
            ),
          ))

             //) ,
            ],
          ),
        ),
      ),
    );
  }
 //  DataRow recentFileDataRow(ReadingWithCount truckData) {
 //    return DataRow(
 //        cells: [
 //          DataCell(Text(truckData.bay)),  //bat
 //          DataCell(Text(truckData.brand)), //brand
 //          DataCell(Text(truckData.ton.toString())), //ton
 //          DataCell(Text(truckData.mrp.toString())), //mrp
 //          DataCell(Text(truckData.truckNo.toString())), //truckNo
 //          DataCell(Text(getDate(truckData.timestamp))),
 //         DataCell(Text(getTime(truckData.readingCountTimestamp))),
 //          DataCell(Text(truckData.allottedBag.toString())),
 //         int.parse(truckData.count ) <0? DataCell(Text('0')):
 //          DataCell(Text(truckData.count.toString())),
 //          int.parse(truckData.count)<0?
 //          DataCell(Text(  truckData.count.toString())):DataCell(Text('0')),
 //
 //        ]);
 //  }
 //
 //  String getDate(String time) {
 //    DateTime dateTime = DateTime.parse(time);
 //    String formattedDate = DateFormat('dd/MM/yy').format(dateTime);
 //
 //    return formattedDate;
 //  }
 // String getTime(String time) {
 //    DateTime dateTime = DateTime.parse(time);
 //    String formattedDate = DateFormat('HH:mm').format(dateTime);
 //
 //    return formattedDate;
 //  }
}


// Your Data Model (Adjust based on your actual model)
// class ReadingWithCount {
//   final String bay;
//   final String brand;
//   final String ton;
//   final String mrp;
//   final String truckNo;
//   final String startTime;
//   final String runningTime;
//   final String bagsCount;
//   final String extraBags;
//
//   ReadingWithCount({
//     required this.bay,
//     required this.brand,
//     required this.ton,
//     required this.mrp,
//     required this.truckNo,
//     required this.startTime,
//     required this.runningTime,
//     required this.bagsCount,
//     required this.extraBags,
//   });
// }
//
// // DataTableSource with GetX Support

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
      int.parse(truckData.count ) <0? DataCell(Text('0')):
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

  String getTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return formattedDate;
  }

}





