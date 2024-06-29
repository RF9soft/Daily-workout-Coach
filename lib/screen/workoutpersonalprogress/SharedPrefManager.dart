import 'package:shared_preferences/shared_preferences.dart';
import '../../model/workout.dart';

class SharedPrefManager {
  static const String workoutKey = 'workouts';

  static Future<void> saveWorkouts(List<Workout> workouts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> workoutList = workouts.map((e) => e.toJsonString()).toList();
    prefs.setStringList(workoutKey, workoutList);
  }

  static Future<List<Workout>> getWorkouts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? workoutList = prefs.getStringList(workoutKey);
    if (workoutList != null) {
      return workoutList.map((e) => Workout.fromJsonString(e)).toList();
    } else {
      return [];
    }
  }
}
