import 'package:flutter/material.dart';
import '../themes/colors.dart';

enum TopicIcon {
  math(Icons.functions),
  microscope(Icons.biotech),
  bookScroll(Icons.history_edu),
  globe(Icons.language),
  book(Icons.menu_book),
  flask(Icons.science),
  compass(Icons.architecture),
  brain(Icons.psychology),
  palette(Icons.palette),
  terminal(Icons.terminal);

  final IconData iconData;
  const TopicIcon(this.iconData);

  String toDbString() => name;

  static TopicIcon fromDbString(String name) {
    return TopicIcon.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TopicIcon.math,
    );
  }
}

class IconSelector extends StatelessWidget {
  final String label;
  final TopicIcon? selectedIcon;
  final ValueChanged<TopicIcon> onIconSelected;

  const IconSelector({
    super.key,
    required this.label,
    this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.gray200),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: TopicIcon.values.map((topicIcon) {
            final isSelected = topicIcon == selectedIcon;

            return GestureDetector(
              onTap: () => onIconSelected(topicIcon),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primaryDarkAccent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Icon(
                    topicIcon.iconData,
                    size: 28,
                    color: isSelected ? AppColors.light : AppColors.gray200,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
