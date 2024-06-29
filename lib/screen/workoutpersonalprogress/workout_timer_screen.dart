import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../controller/workoutcontroller.dart';
import '../../model/workout.dart';

class WorkoutTimerScreen extends StatefulWidget {
  final Workout workout;
  final WorkoutController workoutController = Get.put(WorkoutController());

  WorkoutTimerScreen({required this.workout});

  @override
  _WorkoutTimerScreenState createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  late Timer _timer;
  int _currentDuration = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _startWorkoutTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startWorkoutTimer() {
    _currentDuration = widget.workout.duration * 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentDuration > 0) {
          _currentDuration--;
        } else {
          _timer.cancel();
          _finishWorkout();
        }
      });
    });
    _isRunning = true;
  }

  void _finishWorkout() {
    // Save workout to shared preferences or database
    widget.workoutController.addWorkout(widget.workout);
    Get.back(); // Navigate back to workout personal screen
    Get.snackbar('Workout Completed', 'Workout duration: ${widget.workout.duration} minutes');
  }

  void _cancelWorkout() {
    _timer.cancel();
    Get.back(); // Navigate back to workout personal screen
    Get.snackbar('Workout Canceled', 'Workout canceled.');
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (_currentDuration / (widget.workout.duration * 60));

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Countdown Timer
            CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 12.0,
              percent: progress,
              center: Text(
                '${_currentDuration ~/ 60}:${(_currentDuration % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 20.0),
              ),
              backgroundColor: Colors.greenAccent,
              progressColor: Colors.blue,
            ),
            SizedBox(height: 10),
            // Workout Image
            Image.asset(
              'assets/images/${widget.workout.name.toLowerCase().replaceAll(' ', '_')}.png',
              height: 120,
            ),
            SizedBox(height: 20),
            // Workout Name
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 24, color: Colors.black),
                children: [
                  TextSpan(text: 'Workout\n'),
                  TextSpan(
                    text: widget.workout.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Cancel/End Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _cancelWorkout : null,
                  child: Text('Cancel Workout'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? null : () => Get.back(),
                  child: Text('End Workout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
