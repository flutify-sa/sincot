import 'package:flutter/material.dart';

class MyProfileButton extends StatelessWidget {
  final VoidCallback? onTap; // Nullable VoidCallback
  final String text;
  final bool isActive;

  const MyProfileButton({
    super.key,
    this.onTap, // Make onTap nullable
    required this.text,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    // If the button is inactive, return an empty SizedBox (invisible)
    if (!isActive) {
      return SizedBox.shrink(); // Makes the button invisible
    }

    // If the button is active, return the ElevatedButton
    return ElevatedButton(
      onPressed: onTap, // Use the provided onTap callback
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade700, // Button color
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
