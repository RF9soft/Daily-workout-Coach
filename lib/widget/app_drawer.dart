import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kettlebell/common/app_images.dart';
import 'package:kettlebell/screen/nutrition/news_page_screen.dart';
import 'package:kettlebell/screen/subscription/subscription_screen.dart';
import 'package:kettlebell/screen/workoutpersonalprogress/ProgressScreen.dart';
import '../common/app_colors.dart';
import '../screen/question/question_screen.dart';
import '../screen/subscription/about_screen.dart';
import '../screen/exercisedb/exercise_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../screen/subscription/biceps_exercise_screen.dart';


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
            'Version 1.6',
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
              'Workout Progress',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () async {
              Get.to(() =>   ProgressScreen());

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
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: colorPrimaryDark),
            title: const Text(
              'Get Premium',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () {
              Get.to(() => SubscriptionScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: colorPrimaryDark),
            title: const Text(
              'Share with friends',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () {
              _shareApp();
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer, color: colorPrimaryDark),
            title: const Text(
              'Common questions',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () {

              Get.to(() => QuestionScreen());
            },
          ),
        ],
      ),
    );
  }
}
void _shareApp() {
  Share.share('Check out this amazing workout app: https://play.google.com/store/apps/details?id=com.fitness.power_pulse');

}