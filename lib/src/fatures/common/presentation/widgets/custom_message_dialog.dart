import 'package:flutter/material.dart';

class CustomMessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final Color titleBackgroundColor;
  final IconData icon;

  const CustomMessageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.titleBackgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top colored section with icon
          Container(
            decoration: BoxDecoration(
              color: titleBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            child: Icon(icon, color: Colors.white, size: 60.0),
          ),
          const SizedBox(height: 16.0),
          // Title text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8.0),
          // Message text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          // Button
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondary, // Set to secondary color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 12.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
