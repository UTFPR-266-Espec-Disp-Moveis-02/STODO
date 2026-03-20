import 'package:flutter/widgets.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}

class AppLogoHorizontal extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppLogoHorizontal({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_horizontal.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
