import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

/// Full-screen or inline loading indicator using the `loading_indicator` package.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.fullScreen = true,
    this.indicatorType = Indicator.ballSpinFadeLoader,
  });

  final bool fullScreen;

  /// The style of the loading animation (from [Indicator] enum).
  final Indicator indicatorType;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    final indicator = SizedBox(
      width: 48,
      height: 48,
      child: LoadingIndicator(
        indicatorType: indicatorType,
        colors: [color],
        strokeWidth: 2,
      ),
    );

    if (!fullScreen) return Center(child: indicator);

    return Scaffold(
      body: Center(child: indicator),
    );
  }
}

/// Shimmer placeholder for content-loading states.
///
/// Wrap any skeleton widget with [AppShimmer] to apply the shimmer effect.
///
/// Example:
/// ```dart
/// AppShimmer(
///   child: Container(
///     height: 80,
///     decoration: BoxDecoration(
///       color: Colors.white,
///       borderRadius: BorderRadius.circular(12),
///     ),
///   ),
/// )
/// ```
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E2235) : const Color(0xFFE8EAED),
      highlightColor:
          isDark ? const Color(0xFF2A2F4A) : const Color(0xFFF5F5F5),
      child: child,
    );
  }
}
