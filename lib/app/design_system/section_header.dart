import 'package:flutter/material.dart';
import '../../core/themes/theme_exports.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkAccent.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s12,
        horizontal: AppSpacing.s16,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
