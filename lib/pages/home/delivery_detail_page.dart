import 'package:flutter/material.dart';

class DeliveryDetailPage extends StatelessWidget {
  const DeliveryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengiriman'),
      ),
      body: Center(
        child: Text('Detail Pengiriman'),
      ),
    );
  }
}
