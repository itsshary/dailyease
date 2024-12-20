import 'package:flutter/material.dart';

class StoreCreatingHomeScreen extends StatefulWidget {
  const StoreCreatingHomeScreen({super.key});

  @override
  State<StoreCreatingHomeScreen> createState() =>
      _StoreCreatingHomeScreenState();
}

class _StoreCreatingHomeScreenState extends State<StoreCreatingHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Store Creating Screen"),
      ),
    );
  }
}
