import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/api/keys/api_keys.dart';
import 'package:weather_app/core/Utilities/Validators/validator.dart';
import 'package:weather_app/presentation/styles/app_colors.dart';
import 'package:weather_app/presentation/styles/spacing.dart';
import 'package:weather_app/presentation/styles/text_styles.dart';
import 'package:weather_app/presentation/views/Home/home_viewmodel.dart';
import 'package:weather_app/presentation/views/details/details.dart';

class TimeBreakDownTile extends ConsumerStatefulWidget {
  const TimeBreakDownTile({super.key});

  @override
  ConsumerState<TimeBreakDownTile> createState() => _TimeBreakDownTileState();
}

class _TimeBreakDownTileState extends ConsumerState<TimeBreakDownTile> {
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(homeProvider);
    return Expanded(
      child: SizedBox(
        // color: Colors.blue,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: AppSpacings.horizontalPadding,
              child: Row(
                children: [
                  Row(
                    children: ["Today", "Tomorrow"].mapIndexed((index, e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            if (provider.isLoading) {
                              return;
                            }
                            provider.onChangedDayIndex = index;
                            if (index == 0) {
                              provider.getChosenDaysAverage(
                                  chosenDate: DateTime.now());
                              return;
                            }
                            provider.getChosenDaysAverage(
                                chosenDate: DateTime.now()
                                    .add(const Duration(days: 1)));
                          },
                          child: Text(
                            e,
                            style: AppTextStyle.bodyThree.copyWith(
                              color: provider.onChangedDayIndex == index
                                  ? AppColors.white
                                  : AppColors.textGray,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (provider.isLoading) {
                        return;
                      }
                      context.goNamed(DetailsPage.routeIdentifier,
                          extra: provider.weatherModel);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Next 5 Days",
                          style: AppTextStyle.bodyThree.copyWith(
                            color: AppColors.textGray,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppColors.textGray,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 200,
              child: provider.isLoading
                  ? Shimmer.fromColors(
                      baseColor: AppColors.primaryGradient2,
                      highlightColor: AppColors.primaryGradient3,
                      child: Padding(
                        padding: AppSpacings.horizontalPadding,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.containerColor,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    )
                  : provider.selectedDaysAverage!.isEmpty
                      ? Padding(
                          padding: AppSpacings.horizontalPadding,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.containerColor,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 10),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    color: AppColors.timeTileColor
                                        .withOpacity(0.1))
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "No data to show at this time",
                                style: AppTextStyle.bodyThree.copyWith(
                                  color: AppColors.textGray,
                                ),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          clipBehavior: Clip.none,
                          padding: AppSpacings.horizontalPadding,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 200,
                              // width: 600,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.containerColor,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 10),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                      color: AppColors.timeTileColor
                                          .withOpacity(0.1))
                                ],
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.selectedDaysAverage!.length,
                                itemBuilder: (context, index) {
                                  var item =
                                      provider.selectedDaysAverage![index];
                                  return Container(
                                    height: 100,
                                    width: 60,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColors.timeTileColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          Validators.dateTimeToAMString(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    item.dt! * 1000)
                                                .toLocal(),
                                          ),
                                          style: AppTextStyle.bodyFour.copyWith(
                                            color: AppColors.gray.shade500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${ApiKeys.weatherIcon}${item.weather?.first.icon}@2x.png",
                                            placeholder: (context, url) =>
                                                const SizedBox(),
                                          ),
                                        ),
                                        Text(
                                          "${item.main?.temp?.toStringAsFixed(0)}\u00B0",
                                          style: AppTextStyle.bodyFive.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 15,
                                ),
                              ),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}
