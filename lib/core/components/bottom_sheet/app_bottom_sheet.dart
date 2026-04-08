import 'package:flutter/material.dart';
import 'package:stodo/core/themes/colors.dart';
import 'package:stodo/core/themes/spacing.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const AppBottomSheet({super.key, required this.title, required this.child});

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget Function(BuildContext) builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.s24),
        ),
      ),
      builder: (ctx) => AppBottomSheet(title: title, child: builder(ctx)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.s12,
        horizontal: AppSpacing.s24,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(AppSpacing.s4),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.light,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: AppSpacing.s24,
                    color: AppColors.gray200,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),
            child,
          ],
        ),
      ),
    );
  }
}
