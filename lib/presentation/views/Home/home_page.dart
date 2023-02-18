import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/api/keys/api_keys.dart';
import "package:weather_app/core/Extensions/extensions.dart";
import 'package:weather_app/core/Utilities/Validators/validator.dart';
import 'package:weather_app/presentation/styles/app_colors.dart';
import 'package:weather_app/presentation/styles/spacing.dart';
import 'package:weather_app/presentation/styles/text_styles.dart';
import 'package:weather_app/presentation/views/Home/home_viewmodel.dart';
import 'package:weather_app/presentation/views/Home/widgets/header_tile.dart';
import 'package:weather_app/presentation/views/Home/widgets/selected_day_tile.dart';
import 'package:weather_app/presentation/views/Home/widgets/time_breakdown_tile.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeIdentifier = "HOME_PAGE";
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    _fetchData();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await ref.read(homeProvider).initialize();
    // });
    super.initState();
  }

  Future<void> _fetchData() async {
    await ref.read(homeProvider).initialize();
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
            stops: const [0, 0.5, 1],
            colors: [
              AppColors.primary.withOpacity(1),
              AppColors.primaryGradient2,
              AppColors.primaryGradient3,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const HeaderTile(),
                const SelectedDayTile(),
                const TimeBreakDownTile()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
