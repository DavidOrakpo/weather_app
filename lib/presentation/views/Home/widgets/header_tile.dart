import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/core/Utilities/Validators/validator.dart';
import 'package:weather_app/presentation/styles/app_colors.dart';
import 'package:weather_app/presentation/styles/spacing.dart';
import 'package:weather_app/presentation/styles/text_styles.dart';
import 'package:weather_app/presentation/views/Home/home_viewmodel.dart';

class HeaderTile extends ConsumerStatefulWidget {
  const HeaderTile({super.key});

  @override
  ConsumerState<HeaderTile> createState() => _HeaderTileState();
}

class _HeaderTileState extends ConsumerState<HeaderTile> {
  Timer? timer;
  bool? animate = false;
  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(milliseconds: 650),
      (timer) {
        setState(() {
          animate = !animate!;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(homeProvider);
    return provider.isLoading
        ? !provider.locationServiceEnabled!
            ? GestureDetector(
                onTap: () async {
                  await provider.initialize();
                },
                child: const Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Icon(
                      Icons.refresh,
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
            : Flexible(
                child: Center(
                  child: AnimatedScale(
                    scale: animate! ? 2 : 1,
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeIn,
                    child: Image.asset(
                      "assets/icons/cloudy_load3.png",
                      height: 60,
                      width: 100,
                    ),
                  ),
                ),
              )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Align(
                  alignment: Alignment.topRight,
                  child: !provider.locationServiceEnabled!
                      ? GestureDetector(
                          onTap: () async {
                            await provider.initialize();
                          },
                          child: const Icon(
                            Icons.refresh,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(
                          Icons.menu_outlined,
                          color: AppColors.white,
                        ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: AppSpacings.horizontalPadding,
                child: AnimatedOpacity(
                  duration: const Duration(
                    seconds: 1,
                  ),
                  opacity: provider.isLoading ? 0 : 1,
                  child: Text(
                    "${provider.weatherModel?.city?.name}",
                    style:
                        AppTextStyle.headerTwo.copyWith(color: AppColors.white),
                  ),
                ),
              ),
              SizedBox(
                height: provider.isLoading ? 20 : 0,
              ),
              Padding(
                padding: AppSpacings.horizontalPadding,
                child: AnimatedOpacity(
                  duration: const Duration(
                    seconds: 1,
                  ),
                  opacity: provider.isLoading ? 0 : 1,
                  child: Text(
                    "${provider.weatherModel?.city?.country}",
                    style: AppTextStyle.headerThree
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: AppSpacings.horizontalPadding,
                child: Text(
                  Validators.dateTimeToString(provider.selectedDate!),
                  style: AppTextStyle.headerFive.copyWith(
                    color: AppColors.textGray,
                  ),
                ),
              ),
            ],
          );
  }
}
