import 'package:stodo/core/themes/theme_exports.dart';
import 'package:flutter/material.dart';

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

class IconSelector extends StatefulWidget {
  final String label;
  final TopicIcon? selectedIcon;
  final ValueChanged<TopicIcon> onIconSelected;
  final String? Function(TopicIcon?)? validator;
  final AutovalidateMode? autovalidateMode;

  const IconSelector({
    super.key,
    required this.label,
    this.selectedIcon,
    required this.onIconSelected,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<IconSelector> createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  final _fieldKey = GlobalKey<FormFieldState<TopicIcon>>();

  @override
  Widget build(BuildContext context) {
    return FormField<TopicIcon>(
      key: _fieldKey,
      initialValue: widget.selectedIcon,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: state.hasError ? AppColors.topicColor2 : AppColors.gray200,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: TopicIcon.values.map((topicIcon) {
                final isSelected = topicIcon == widget.selectedIcon;
                return GestureDetector(
                  onTap: () {
                    widget.onIconSelected(topicIcon);
                    state.didChange(topicIcon);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.primaryDarkAccent,
                      borderRadius: BorderRadius.circular(AppSpacing.s16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 2)]
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
            if (state.hasError) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                state.errorText!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.topicColor2),
              ),
            ],
          ],
        );
      },
    );
  }
}
