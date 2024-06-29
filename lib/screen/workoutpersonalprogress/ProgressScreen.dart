import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kettlebell/screen/workoutpersonalprogress/personal_workout_screen.dart';

import '../../controller/workoutcontroller.dart';


class ProgressScreen extends StatelessWidget {
  final WorkoutController workoutController = Get.put(WorkoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (workoutController.workouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No progress yet',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => WorkoutPersonalScreen());
                    },
                    child: Text('Start Workout'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: workoutController.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutController.workouts[index];
                return ListTile(
                  title: Text(workout.name),
                  subtitle: Text(
                    'Date: ${workout.date.toLocal().toString().split(' ')[0]} - Duration: ${workout.duration} minutes',
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
