import 'package:flutter/material.dart';

import '../../../core/components/states/skeletons/book_card_skeleton.dart';
import '../../../core/components/states/skeletons/skeleton.dart';
import '../../../core/components/states/skeletons/topic_card_skeleton.dart';
import '../../../core/themes/theme_exports.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skeleton(height: 20, width: 120, borderRadius: AppSpacing.s4),
            const SizedBox(height: AppSpacing.s16),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.s16),
                itemBuilder: (context, index) => const BookCardSkeleton(),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            const Skeleton(height: 20, width: 100, borderRadius: AppSpacing.s4),
            const SizedBox(height: AppSpacing.s16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => const TopicCardSkeleton(),
            ),
          ],
        ),
      ),
    );
  }
}
