import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kettlebell/common/app_images.dart';
import 'package:kettlebell/screen/biceps_exercise_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/app_colors.dart';
import '../screen/about_screen.dart';
import '../screen/exercisedb/exercise_screen.dart';


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
            'Version 1.4',
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
              'ASK AI',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () async {
              const url = 'https://play.google.com/store/apps/details?id=com.mentor.virtuai&pcampaignid=web_share';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
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
              'Life Mentor',
              style: TextStyle(color: colorBlack),
            ),
            onTap: () async {
              const url = 'https://play.google.com/store/apps/details?id=com.life.mentor&pcampaignid=web_share';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
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
