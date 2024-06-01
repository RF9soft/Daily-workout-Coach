import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';


import '../../common/app_colors.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final String name;
  final String gifUrl;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  const ExerciseDetailsScreen(
      {super.key,
      required this.name,
      required this.gifUrl,
      required this.secondaryMuscles,
      required this.instructions});

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);



  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      appBar: AppBar(
        backgroundColor: colorAppBar,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        titleSpacing: -1,
        title: Text(
          capitalize(widget.name),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(widget.gifUrl),
            ),
            Gap(16.h),
            Text(
              'Secondary Muscles:',
              style: TextStyle(
                color: colorBlack,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.secondaryMuscles
                  .map((muscle) => Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 9.h,
                            color: colorCircle,
                          ),
                          Gap(4.w),
                          Text(capitalize(muscle)),
                        ],
                      ))
                  .toList(),
            ),
            Gap(16.h),
            Text(
              'Instructions:',
              style: TextStyle(
                color: colorBlack,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.instructions
                  .map((instruction) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: REdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.circle,
                              size: 9.h,
                              color: colorCircle,
                            ),
                          ),
                          Gap(4.w),
                          SizedBox(
                            width: 300.w,
                            child: Text(
                              capitalize(instruction),
                              maxLines: 4,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: colorBlack,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
