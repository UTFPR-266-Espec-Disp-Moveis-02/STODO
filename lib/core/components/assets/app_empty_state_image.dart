import 'package:flutter/widgets.dart';

class AppEmptyStateImage extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppEmptyStateImage({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/empty_state.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
