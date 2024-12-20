import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white, // Text color
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
