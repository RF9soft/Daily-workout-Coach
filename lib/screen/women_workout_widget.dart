import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kettlebell/common/app_images.dart';
import 'package:kettlebell/screen/women/workout_women_details_screen.dart';

class WomenWorkoutWidget extends StatelessWidget {
  // List of workout items with their names and images
  final List<Map<String, dynamic>> workoutItems = [
    {
      'name': 'Push-ups',
      'image': pushup,
    },
    {
      'name': 'Squats',
      'image': squat,
    },
    {
      'name': 'Leg Raises',
      'image': leg,
    },
    // Add more workout items as needed
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final itemWidth = screenWidth * 0.4;
    final itemHeight = screenWidth * 0.33;

    return Container(
      height: itemHeight + 40, // Adjust the height according to your needs
      child: CarouselSlider.builder(
        itemCount: workoutItems.length,
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 0.6,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return _buildWorkoutCard(
              context, workoutItems[index], itemWidth, itemHeight);
        },
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context,
      Map<String, dynamic> workoutItem, double itemWidth, double itemHeight) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                WorkoutDetailsScreen(
                  name: workoutItem['name'],
                  image: workoutItem['image'],
                ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          elevation: 0.0,
          shadowColor: Colors.greenAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: itemWidth,
                height: itemHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(workoutItem['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                workoutItem['name'],
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}