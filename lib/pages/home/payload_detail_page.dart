import 'package:flutter/material.dart';

class PayloadDetailPage extends StatelessWidget {
  const PayloadDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Muatan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text('Payload Detail'),
      ),
    );
  }
}
