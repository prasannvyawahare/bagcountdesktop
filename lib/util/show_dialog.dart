import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class FileAlert {
  static void showFileSavedDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Exported'),
        content: SelectableText('File saved at:\n$filePath'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              OpenFilex.open(filePath); // Open the file
              Navigator.pop(context);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}
