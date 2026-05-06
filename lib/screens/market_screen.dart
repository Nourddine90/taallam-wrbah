import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سوق الحومة'), backgroundColor: Colors.teal),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🛒', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('بيع وشراء المنتوجات', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
