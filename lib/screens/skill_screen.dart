import 'package:flutter/material.dart';

class SkillScreen extends StatelessWidget {
  const SkillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعلم حرفة'), backgroundColor: Colors.teal),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎓', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('فيديوهات تعليمية', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
