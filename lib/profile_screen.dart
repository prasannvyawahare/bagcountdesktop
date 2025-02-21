import 'package:bagreportun/repository/user_repository.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String softwareVersion;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.softwareVersion,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository _userRepository = UserRepository();
  String _fullName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserName(widget.userId);
  }

  Future<void> _fetchUserName(String username) async {
    final user = await _userRepository.getUserByUsername(username);
    setState(() {
      _fullName = user?.username ?? 'Admin';
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white60,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfo(title: 'Full Name', value: _fullName),
              const SizedBox(height: 10),
              ProfileInfo(title: 'User ID', value: widget.userId),
              const SizedBox(height: 10),
              ProfileInfo(title: 'Software Version', value: widget.softwareVersion),
              const SizedBox(height: 20),
              Container(
                 // height: double.infinity,
                  width: double.infinity,
        
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
        
                         Text(
                           'Software Working Instructions',
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
        
                         const SizedBox(height: 20),
                        Text(
                           '1. Verify Data in Terminal Software',
                           style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(height: 5),
                         Text(
                           '\u2022 Ensure the first data is correctly displayed in the terminal software before proceeding with the Wi-Bag counting system.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                         const SizedBox(height: 20),
        
                        Text(
                           '2. Connect Hardware Serial Port',
                           style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(height: 5),
                         Text(
                           '\u2022 Attach the hardware serial port to the system securely.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                         const SizedBox(height: 20),
        
                        Text(
                           '3. Select and Connect the Port',
                           style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(height: 5),
                         Text(
                           '\u2022 Navigate to the Port Section.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                          Text(
                           '\u2022 Choose the appropriate port.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                           Text(
                           '\u2022 Click the Connect button to establish the connection.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                         const SizedBox(height: 20),

                   Text(
                           '4. Monitor the Dashboard',
                           style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(height: 5),
                         Text(
                           '\u2022 The Dashboard displays:',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                 '\u2022 Most recent data.',
                                 style: TextStyle(
                                   fontSize: 14,
                                 ),
                                                         ),
                                 Text(
                                 '\u2022 Port connection status.',
                                 style: TextStyle(
                                   fontSize: 14,
                                 ),
                                 ),
                                  Text(
                                 '\u2022 Shift details',
                                 style: TextStyle(
                                   fontSize: 14,
                                 ),
                                   ),
                                 Text(
                                 '\u2022 Brand details.',
                                 style: TextStyle(
                                   fontSize: 14,
                                 ),
                                                         ),
                               Text(
                                 '\u2022 Total extra bag count',
                                 style: TextStyle(
                                   fontSize: 14,
                                 ),
                                                         ),
                              ],
                            ),
                          ),
                         const SizedBox(height: 20),
                         Text(
                           '6. Create a New Shift',
                           style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(height: 5),
                         Text(
                           '\u2022 Go to the Shift Section.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                         Text(
                           '\u2022 CAdd a new shift as required.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                         const SizedBox(height: 20),
                       Text(
                           '7. Create a New Brand',
                           style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(height: 5),
                         Text(
                           '\u2022 Go to the Brand Section.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                         Text(
                           '\u2022 Add a new brand as needed.',
                           style: TextStyle(
                             fontSize: 14,
                           ),
                         ),
                         const SizedBox(height: 20),
                       ],
                    ),
                  )
        
        
              )
        
        
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfo({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}


