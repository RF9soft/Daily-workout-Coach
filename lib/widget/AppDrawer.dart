import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kettlebell/common/AppImages.dart';
import 'package:kettlebell/screen/BicepsExerciseScreen.dart';

import '../common/AppColors.dart';
import '../screen/about_screen.dart';
import '../screen/exercisedb/ExerciseScreen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colorDrawerBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(80.h),
          Text(
            'My Workout',
            style: TextStyle(
              color: colorBlack,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Version 1.1',
            style: TextStyle(
              color: colorBlack,
            ),
          ),
          Gap(50.h),

          ListTile(
            leading: SvgPicture.asset(
              list,
              height: 16.h,
              width: 16.w,
              color: colorPrimaryDark,
            ),
            title: const Text(
              'Exercise List',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () {
              Get.to(() => const ExerciseScreen());
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              bell,
              height: 16.h,
              width: 16.w,
              color: colorPrimaryDark,
            ),
            title: const Text(
              'Exercises',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () {
              Get.to(() => const BicepsExerciseScreen());
            },
          ),


          ListTile(
            leading: SvgPicture.asset(
              info,
              height: 16.h,
              width: 16.w,
              color: colorPrimaryDark,
            ),
            title: const Text(
              'About App',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () {
              Get.to(() => AboutAppScreen());
            },
          ),
        ],
      ),
    );
  }
}
