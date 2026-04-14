import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';

import 'skeleton.dart';

class BookListCardSkeleton extends StatelessWidget {
  const BookListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.s16),

      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryMedium,
          borderRadius: BorderRadius.circular(AppSpacing.s16),
          border: Border.all(color: AppColors.primaryDarkAccent, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 📘 CAPA
              const Skeleton(
                width: 56,
                height: 76,
                borderRadius: AppSpacing.s8,
              ),

              const SizedBox(width: AppSpacing.s16),

              /// 📄 CONTEÚDO
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      /// TÍTULO
                      Skeleton(width: double.infinity, height: 14),

                      SizedBox(height: AppSpacing.s4),

                      /// AUTOR
                      Skeleton(width: 120, height: 12),

                      SizedBox(height: AppSpacing.s12),

                      /// STATUS / PROGRESS
                      Skeleton(width: 100, height: 12),

                      SizedBox(height: AppSpacing.s4),

                      /// BARRA DE PROGRESSO
                      Skeleton(
                        width: double.infinity,
                        height: 6,
                        borderRadius: AppSpacing.s4,
                      ),
                    ],
                  ),
                ),
              ),

              /// ⋮ MENU
              const Skeleton(width: 24, height: 24, shape: BoxShape.circle),
            ],
          ),
        ),
      ),
    );
  }
}
