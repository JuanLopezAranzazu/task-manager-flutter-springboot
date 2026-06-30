import 'package:flutter/material.dart';
import '../config/app_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt_rounded, size: 72, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Task Manager',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              color: Colors.white70,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
