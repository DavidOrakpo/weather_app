import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/api/keys/api_keys.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/main.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/weather_model.dart';
import 'package:weather_app/core/Utilities/Validators/validator.dart';
import 'package:weather_app/presentation/styles/app_colors.dart';
import 'package:weather_app/presentation/styles/text_styles.dart';
import 'package:weather_app/presentation/views/details/details_viewmodel.dart';

class DetailsPage extends ConsumerStatefulWidget {
  static const routeIdentifier = "DETAILS_PAGE";
  final WeatherModel weatherModel;
  const DetailsPage({super.key, required this.weatherModel});

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  @override
  void initState() {
    ref
        .read(detailsProvider)
        .computeTemperatureDailyAverage(widget.weatherModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(detailsProvider);
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Text(
                "Next 5 Days",
                style: AppTextStyle.headerTwo,
              ),
              const SizedBox(
                height: 100,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.daysDetailed!.length,
                itemBuilder: (context, index) {
                  var item = provider.daysDetailed![index];
                  return Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          Validators.dateTimeToWeekDay(item.day),
                          style: AppTextStyle.bodyThree.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: item.icon == null
                              ? const Icon(
                                  Icons.clear,
                                  color: AppColors.black,
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${ApiKeys.weatherIcon}${item.icon}@2x.png",
                                  placeholder: (context, url) =>
                                      const SizedBox(),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.temperature == null
                              ? "~"
                              : "${item.temperature!.toStringAsFixed(0)}\u00B0",
                          style: AppTextStyle.bodyThree.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
