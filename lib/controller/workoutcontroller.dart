import 'package:get/get.dart';
import '../model/workout.dart';
import '../screen/workoutpersonalprogress/SharedPrefManager.dart';
import '../screen/workoutpersonalprogress/workout_exercise.dart';


class WorkoutController extends GetxController {
  var workouts = <Workout>[].obs;
  var exercises = <WorkoutExercise>[
    WorkoutExercise(name: 'Push Up', image: 'assets/images/waist.png'),
    WorkoutExercise(name: 'Squat', image: 'assets/images/legs.png'),
    // Add more exercises as needed
  ].obs;
  var selectedExercise = Rx<WorkoutExercise?>(null);
  var selectedDuration = 30.obs;

  @override
  void onInit() {
    super.onInit();
    _loadWorkouts();
  }

  void addWorkout(Workout workout) {
    workouts.add(workout);
    SharedPrefManager.saveWorkouts(workouts);
  }

  void selectExercise(WorkoutExercise exercise) {
    selectedExercise.value = exercise;
  }

  Future<void> _loadWorkouts() async {
    workouts.value = await SharedPrefManager.getWorkouts();
  }

  int get totalWorkouts => workouts.length;

  int get totalDuration => workouts.fold(0, (sum, item) => sum + item.duration);
}
