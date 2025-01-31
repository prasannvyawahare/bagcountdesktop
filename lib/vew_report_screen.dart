import 'package:bagreportun/repository/reading_repository.dart';
import 'package:flutter/material.dart';

import 'model/reading.dart';

class VewReportScreen extends StatefulWidget {
  const VewReportScreen({super.key});


  @override
  State<VewReportScreen> createState() => _VewReportScreenState();
}

class _VewReportScreenState extends State<VewReportScreen> {
  final ReadingRepository _readingRepository = ReadingRepository();
   List<Reading> readings = [];
  List<String> _mapList = ["All","Google Maps", "Apple Maps", "Bing Maps", "OpenStreetMap"];
  String? _selectedMap; // Variable to store the selected map

  List<String> _shiftList = ["All","A", "B", "C", "D"];
  String? _selectedShift; // Variable to store the selected map
   DateTime? _fromDate;
   DateTime? _toDate;
   TimeOfDay? _fromTime;
   TimeOfDay? _toTime;
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

   void readDataFromDB() async {
     readings = await _readingRepository.getAllReadings();
     print(readings);
     setState(() {

     });
   }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataFromDB();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Report"  ,style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter Section
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!, width: 1),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("From Date", style: TextStyle(color: Colors.black54)),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _selectDate(context, true),
                                        child: Container(
                                          width: 120,
                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            _fromDate != null
                                                ? "${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}"
                                                : "DD/MM/YYYY",
                                            style: TextStyle(color: Colors.black45, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("TO Date", style: TextStyle(color: Colors.black54)),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _selectDate(context, false),
                                        child: Container(
                                          width: 120,
                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            _toDate != null
                                                ? "${_toDate!.day}/${_toDate!.month}/${_toDate!.year}"
                                                : "DD/MM/YYYY",
                                            style: TextStyle(color: Colors.black45, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("From Time", style: TextStyle(color: Colors.black54)),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _selectTime(context, true),
                                        child: Container(
                                          width: 120,
                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            _fromTime != null
                                                ? "${_fromTime!.hour}:${_fromTime!.minute.toString().padLeft(2, '0')}"
                                                : "HH:MM",
                                            style: TextStyle(color: Colors.black45, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("To Time", style: TextStyle(color: Colors.black54)),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _selectTime(context, false),
                                        child: Container(
                                          width: 120,
                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            _toTime != null
                                                ? "${_toTime!.hour}:${_toTime!.minute.toString().padLeft(2, '0')}"
                                                : "HH:MM",
                                            style: TextStyle(color: Colors.black45, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title for the dropdown
                                      Text("Brand", style: TextStyle(color: Colors.black54)),
                                      SizedBox(height: 8),
                                      // Dropdown for selecting a map
                                      Container(
                                       height: 35,
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: DropdownButton<String>(
                                          value: _selectedMap, // Currently selected value
                                          isExpanded: true, // Makes the dropdown take full width
                                          underline: SizedBox(), // Removes the default underline
                                          items: _mapList.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(color: Colors.black45, fontSize: 12),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedMap = newValue; // Update the selected value
                                            });
                                          },
                                          hint: Text("Select", style: TextStyle(color: Colors.black45, fontSize: 12)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title for the dropdown
                                      Text("Shift", style: TextStyle(color: Colors.black54)),
                                      SizedBox(height: 8),
                                      // Dropdown for selecting a map
                                      Container(
                                        height: 35,

                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: DropdownButton<String>(
                                          value: _selectedShift, // Currently selected value
                                          isExpanded: true, // Makes the dropdown take full width
                                          underline: SizedBox(), // Removes the default underline
                                          items: _shiftList.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(color: Colors.black45, fontSize: 12),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedShift = newValue; // Update the selected value
                                            });
                                          },
                                          hint: Text("Select", style: TextStyle(color: Colors.black45, fontSize: 12)),
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
                                    Radio(value: true, groupValue: true, onChanged: (val) {}),
                                    Text('Hourly'),
                                    SizedBox(width: 16),
                                    Radio(value: false, groupValue: true, onChanged: (val) {}),
                                    Text('Shift-wise'),
                                    SizedBox(width: 16),
                                    Radio(value: false, groupValue: true, onChanged: (val) {}),
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
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    ),
                                    child: Text("Apply", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text("Excel Download", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text("PDF Downloan", style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              //show filter data
              Row(children: [

                Row(
                  children: [
                    Text(
                      "Date: ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "02/07/2024",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      " To ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "02/07/2024",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Row(
                  children: [
                    Text(
                      "Time: ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "00:00",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      " To ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "23:59",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Row(
                  children: [
                    Text(
                      "Brand: ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "All",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Row(
                  children: [
                    Text(
                      "Shift: ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "All",
                      style: TextStyle(fontSize: 16,),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Text(
                  "Reset Filter",
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.red[700]),
                ),

              ],),
              SizedBox(height: 20),
              readings.length>0?Container(
                height: 300,
                child: ListView.builder(
                  itemCount: readings.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(readings[index].value.toString()),
                    );
                  },
                ),
              ):Container(
                child: Center(
                  child: Text("No Data Found"),
                ),
              ),
              // Table Section
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Container(
              //       // decoration: BoxDecoration(
              //       //   borderRadius: BorderRadius.circular(12),
              //       //   border: Border.all(color: Colors.grey[300]!, width: 1),
              //       //   color:Colors.grey[100],
              //       // ),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(12), // Rounded corners for the DataTable
              //
              //         child: DataTable(
              //           headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade100), // Title row color
              //           dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Data row color
              //           //columnSpacing: 10,
              //           columnSpacing: 10,
              //           columns: const [
              //             DataColumn(
              //               label: SizedBox(
              //                 width: 50, // Adjust width for Sr.No.
              //                 child: Text('Sr.No.',textAlign: TextAlign.left),
              //               ),
              //             ),
              //             DataColumn(
              //               label: SizedBox(
              //                 width: 50, // Adjust width for Sr.No.
              //                 child: Text('Shift',textAlign: TextAlign.left),
              //               ),
              //             ),
              //             DataColumn(label: Text('Brand')),
              //             DataColumn(label: Text('Ton')),
              //             DataColumn(label: Text('MRP')),
              //             // DataColumn(label: Text('Truck No.')),
              //             // DataColumn(label: Text('p(+)/m(-) variation')),
              //             // DataColumn(label: Text('Start Time')),
              //             // DataColumn(label: Text('Stop Time')),
              //             // DataColumn(label: Text('Counter Status')),
              //             // DataColumn(label: Text('Bags Allotted')),
              //             DataColumn(label: Text('Extra Bags')),
              //             DataColumn(label: Text('Tech. Name')),
              //           ],
              //           rows: [
              //             DataRow(cells: [
              //               DataCell(Text('1')),
              //               DataCell(Text('User Research and Per...')),
              //               DataCell(Text('July 1, 2024')),
              //               DataCell(Text('Done', style: TextStyle(color: Colors.green))),
              //               DataCell(Text('Submitted')),
              //               DataCell(Text('Submitted')),
              //               DataCell(Text('Submitted')),
              //             ]),
              //             DataRow(cells: [
              //               DataCell(Text('2')),
              //               DataCell(Text('Competitive Analysis...')),
              //               DataCell(Text('July 25, 2024')),
              //               DataCell(Text('July 25, 2024')),
              //               DataCell(Text('Progress', style: TextStyle(color: Colors.blue))),
              //               DataCell(Text('Progress', style: TextStyle(color: Colors.blue))),
              //               DataCell(ElevatedButton(onPressed: () {}, child: Text('Upload'))),
              //             ]),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}