import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kettlebell/screen/workoutpersonalprogress/workout_timer_screen.dart';
import '../../controller/workoutcontroller.dart';
import '../../model/workout.dart';
import 'package:numberpicker/numberpicker.dart';

class WorkoutPersonalScreen extends StatelessWidget {
  final WorkoutController workoutController = Get.put(WorkoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Exercise:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: workoutController.exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = workoutController.exercises[index];
                        return GestureDetector(
                          onTap: () => workoutController.selectExercise(exercise),
                          child: Obx(() {
                            final isSelected = workoutController.selectedExercise.value == exercise;
                            return Container(
                              width: 100,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      exercise.image,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                      height: 60,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      exercise.name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Duration (minutes):',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    return NumberPicker(
                      value: workoutController.selectedDuration.value,
                      minValue: 1,
                      maxValue: 120,
                      onChanged: (value) {
                        workoutController.selectedDuration.value = value;
                      },
                    );
                  }),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Start workout logic
                      if (workoutController.selectedExercise.value != null) {
                        final workout = Workout(
                          name: workoutController.selectedExercise.value!.name,
                          date: DateTime.now(),
                          duration: workoutController.selectedDuration.value,
                        );
                        workoutController.addWorkout(workout);
                        // Navigate to workout timer screen
                        Get.to(() => WorkoutTimerScreen(workout: workout));
                      }
                    },
                    child: Text('Start Workout'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Workouts: ${workoutController.totalWorkouts}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Total Duration: ${workoutController.totalDuration} minutes',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
