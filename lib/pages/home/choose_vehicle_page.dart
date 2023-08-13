import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChooseVehiclePage extends StatelessWidget {
  const ChooseVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Pilih Kendaraan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Text('Choose Vehicle'),
      ),
    );
  }
}
