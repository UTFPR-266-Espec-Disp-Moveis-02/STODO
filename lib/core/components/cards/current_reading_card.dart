import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';

class CurrentReadingCard extends StatelessWidget {
  final String title;
  final String author;
  final String? coverPath;
  final double progress; // 0.0 to 1.0 expected
  final VoidCallback? onTap;

  const CurrentReadingCard({
    super.key,
    required this.title,
    required this.author,
    this.coverPath,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryMedium,
      borderRadius: BorderRadius.circular(AppSpacing.s20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Book Cover Layout
              Container(
                width: 80,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8DE), // Beige background frame
                  borderRadius: BorderRadius.circular(AppSpacing.s12),
                ),
                padding: const EdgeInsets.all(AppSpacing.s8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkAccent,
                    borderRadius: BorderRadius.circular(AppSpacing.s4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                    image: coverPath != null
                        ? DecorationImage(
                            image: FileImage(File(coverPath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: coverPath == null
                      ? const Center(
                          child: Icon(
                            Icons.book,
                            color: AppColors.gray400,
                            size: 24,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              // Content Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LEITURA EM ANDAMENTO',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.light,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      author,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.gray200,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.s4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: AppColors.primaryDarkAccent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.gray200,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
