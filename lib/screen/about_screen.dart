import 'package:flutter/material.dart';
import '../../common/style.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Workout App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Workout App',
              style: AppTextStyles.heading,
            ),
            SizedBox(height: 16),
            Text(
              'Version: 1.0.0',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to the Workout App, your ultimate fitness companion! Whether you are a beginner or a fitness enthusiast, this app is designed to help you achieve your fitness goals and lead a healthier lifestyle.',
              style: AppTextStyles.normal,
            ),
            SizedBox(height: 16),
            Text(
              'Key Features:',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 8),
            Text(
              '- Access a wide range of workout exercises for various muscle groups.',
              style: AppTextStyles.normal,
            ),
            Text(
              '- Follow expert-designed workout routines suitable for all fitness levels.',
              style: AppTextStyles.normal,
            ),
            Text(
              '- Track your progress, set goals, and stay motivated on your fitness journey.',
              style: AppTextStyles.normal,
            ),
            Text(
              '- View detailed exercise instructions and videos to ensure proper form.',
              style: AppTextStyles.normal,
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for choosing Workout App! Start your fitness journey today and transform your body and mind.',
              style: AppTextStyles.italic,
            ),
          ],
        ),
      ),
    );
  }
}
