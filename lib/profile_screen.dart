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
      _fullName = user?.username ?? 'Unknown User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BagCount Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInfo(title: 'Full Name', value: _fullName),
            const SizedBox(height: 10),
            ProfileInfo(title: 'User ID', value: widget.userId),
            const SizedBox(height: 10),
            ProfileInfo(title: 'Software Version', value: widget.softwareVersion),
          ],
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


