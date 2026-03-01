import 'package:flutter/material.dart';
import 'package:dt_digital_studio/core/config/app_flavor.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;

  const FlavorBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Return early without banner in production
    if (FlavorConfig.isProd) {
      return child;
    }

    final bannerConfig = _getDefaultBanner();

    return Stack(
      children: <Widget>[
        child,
        _buildBanner(context, bannerConfig),
      ],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
      bannerName: FlavorConfig.flavor.name.toUpperCase(),
      bannerColor:
          FlavorConfig.isDev ? Colors.redAccent : Colors.orangeAccent,
    );
  }

  Widget _buildBanner(BuildContext context, BannerConfig bannerConfig) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
          message: bannerConfig.bannerName,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
          color: bannerConfig.bannerColor,
        ),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;

  BannerConfig({required this.bannerName, required this.bannerColor});
}
