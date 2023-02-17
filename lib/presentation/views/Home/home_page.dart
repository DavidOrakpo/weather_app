import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/presentation/styles/app_colors.dart';
import 'package:weather_app/presentation/styles/text_styles.dart';
import 'package:weather_app/presentation/views/Home/home_viewmodel.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeIdentifier = "HOME_PAGE";
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    fetchData();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await ref.read(homeProvider).getUsersPosition();
    // });
    super.initState();
  }

  Future<void> fetchData() async {
    await ref.read(homeProvider).getUsersPosition();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(homeProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.4, 1],
            colors: [
              AppColors.primary.withOpacity(1),
              AppColors.primaryGradient2,
              AppColors.primaryGradient3,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.menu_outlined,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "London,",
                  style:
                      AppTextStyle.headerTwo.copyWith(color: AppColors.white),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                Text(
                  "United Kingdom",
                  style:
                      AppTextStyle.headerThree.copyWith(color: AppColors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Sat, 6 Aug",
                  style: AppTextStyle.headerFive.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Expanded(
                    child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Today",
                          style: AppTextStyle.headerThree,
                        ),
                        Text(
                          "22\u00B0",
                          style: AppTextStyle.headerOne,
                        ),
                        Text(
                          "Sunny",
                          style: AppTextStyle.headerFive,
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  color: Colors.blue,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
