import 'package:bagreportun/repository/reading_count_repository.dart';
import 'package:bagreportun/repository/reading_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/serial_port_service.dart';
import 'model/reading_with_count.dart';

class DashboardScreen extends StatefulWidget {
   const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = SerialPortService.instance;
  late ReadingRepository readingRepository ; // Fetch instance
  String bay='',truckNo='',rate='',count='';
  @override
  void initState() {
    getDataFromDb();
    super.initState();
  }
getDataFromDb() async{
  await controller.getAllReadingData();
    setState(() {

    });

 // if( controller.readingWithCountList.length>0) {
 //   ReadingWithCount readingWithCount = controller.readingWithCountList.first;
 //   setState(() {
 //     bay = readingWithCount.reading.bay;
 //     truckNo = readingWithCount.reading.truckNo;
 //     rate = readingWithCount.reading.mrp.toString();
 //     count = readingWithCount.count.toString();
 //   });
 // }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row( children: [

           Container(
      width: 220,
        height: 170,
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
        padding: EdgeInsets.symmetric( vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 3, height: 20, color: Colors.blue),
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "Connect",
                  style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,color:Colors.blue ),
                ),
              ),
            ),
          ],
        ),
      ),
           Container(
             width: 220,
             height: 170,
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
             padding: EdgeInsets.symmetric( vertical: 10),
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Container(width:3,height: 20,color: Colors.amberAccent,),
                     SizedBox(width: 10,),
                     Text(
                       "Shift Available",
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
                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                     child: Text(
                       "0",
                       style: TextStyle(fontSize: 25,
                           fontWeight: FontWeight.bold,color:Colors.amberAccent ),
                     ),
                   ),
                 ),

               ],
             ),
           ),
           Container(
             width: 220,
             height: 170,
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
             padding: EdgeInsets.symmetric( vertical: 10),
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Container(width:3,height: 20,color: Colors.deepPurple,),
                     SizedBox(width: 10,),
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
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                     child: Text(
                       "0",
                       style: TextStyle(fontSize: 25,
                           fontWeight: FontWeight.bold,color:Colors.deepPurple ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
           Container(
             width: 220,
             height: 170,
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
             padding: EdgeInsets.symmetric( vertical: 10),
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Container(width:3,height: 20,color: Colors.green,),
                     SizedBox(width: 10,),
                     Text(
                       "Total Bag Deliver ",
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
                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                     child: Text(
                       "0",
                       style: TextStyle(fontSize: 25,
                           fontWeight: FontWeight.bold,color:Colors.green ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ],),
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
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Wi-Bag Counter',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'RCC PL Nagpur',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child:  controller.readingWithCountList.isNotEmpty?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(()=>
                          _buildParameterRow('Bay',  controller.readingWithCountList.first.bay),
                      ),
                      Obx(()=>
                          _buildParameterRow('Track No',  controller.readingWithCountList.first.truckNo),
                      ),
                      Obx(()=>
                          _buildParameterRow('Rate',  controller.readingWithCountList.first.mrp.toString()),
                      ),
                      Obx(()=>
                          _buildParameterRow('Allotted Bag',  controller.readingWithCountList.first.allottedBag.toString()),
                      ),
                      Obx(()=>
                          _buildParameterRow('Remaining Bag',  controller.readingWithCountList.first.count),
                      ),
                    ],
                  ):Center(child: Text("No Data Available")))
                 ,

                  Expanded(child: Image.asset("images/truck_img.jpg",width: 100,height: 200,)),
                ],),

                // Parameters

                const SizedBox(height: 10),

                // Footer
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Microtron Systems',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
          ],
      ),
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black54
              ),
            ),
          ),
          Text(":"),
          SizedBox(width: 20,),
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color:  Colors.grey[300], // Background color
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Usage: Call WiBagCounter() widget in your app