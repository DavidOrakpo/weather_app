import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/api/keys/api_keys.dart';
import 'package:weather_app/presentation/styles/app_colors.dart';
import 'package:weather_app/presentation/styles/text_styles.dart';
import 'package:weather_app/presentation/views/Home/home_viewmodel.dart';
import "package:weather_app/core/Extensions/extensions.dart";

class SelectedDayTile extends ConsumerStatefulWidget {
  const SelectedDayTile({super.key});

  @override
  ConsumerState<SelectedDayTile> createState() => _SelectedDayTileState();
}

class _SelectedDayTileState extends ConsumerState<SelectedDayTile> {
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(homeProvider);
    return Expanded(
      child: Container(
        // color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                provider.selectedDateTitle!,
                style: AppTextStyle.headerThree.copyWith(
                  color: AppColors.white,
                  height: 1,
                ),
              ),
              provider.threeHourSegmentsDayList!.isEmpty && !provider.isLoading
                  ? Image.asset(
                      "assets/icons/cloudy_load3.png",
                      height: 60,
                      width: 100,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        provider.isLoading
                            ? const SizedBox()
                            : SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${ApiKeys.weatherIcon}${provider.selectedDateIcon}@2x.png",
                                  placeholder: (context, url) =>
                                      const SizedBox(),
                                ),
                              ),
                        Text(
                          provider.isLoading
                              ? "Getting Ready..."
                              : "${provider.selectedDateTemperature?.toStringAsFixed(0)}\u00B0",
                          style: AppTextStyle.headerOne.copyWith(
                            fontSize: provider.isLoading ? 14 : null,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
              provider.threeHourSegmentsDayList!.isEmpty
                  ? const SizedBox()
                  : AnimatedOpacity(
                      opacity: provider.isLoading ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      child: Text(
                        "${provider.selectedDateDescription?.capitalize()}",
                        style: AppTextStyle.headerFive.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
