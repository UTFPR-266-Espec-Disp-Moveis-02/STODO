import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';

import 'custom_text_field.dart';

class ProgressUpdater extends StatefulWidget {
  final int currentValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const ProgressUpdater({
    super.key,
    required this.currentValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  State<ProgressUpdater> createState() => _ProgressUpdaterState();
}

class _ProgressUpdaterState extends State<ProgressUpdater> {
  late TextEditingController _controller;
  late int _localValue;

  @override
  void initState() {
    super.initState();
    _localValue = widget.currentValue;
    _controller = TextEditingController(text: _localValue.toString());
  }

  @override
  void didUpdateWidget(covariant ProgressUpdater oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue) {
      _localValue = widget.currentValue;
      _controller.text = _localValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    if (_localValue < widget.maxValue) {
      setState(() {
        _localValue++;
        _controller.text = _localValue.toString();
      });
      widget.onChanged(_localValue);
    }
  }

  void _decrement() {
    if (_localValue > 0) {
      setState(() {
        _localValue--;
        _controller.text = _localValue.toString();
      });
      widget.onChanged(_localValue);
    }
  }

  void _onInputSubmitted(String value) {
    final int? parsedValue = int.tryParse(value);
    if (parsedValue != null) {
      int clamped = parsedValue.clamp(0, widget.maxValue);
      setState(() {
        _localValue = clamped;
        _controller.text = _localValue.toString();
      });
      widget.onChanged(_localValue);
    } else {
      // Reverter se digitação for inválida
      _controller.text = _localValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s24,
        horizontal: AppSpacing.s20,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryMedium,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        border: Border.all(
          color: AppColors.primaryDarkAccent.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Atualize seu progresso',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.gray200,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          // Large Progress Number
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _localValue.toString(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.light,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' / ${widget.maxValue}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.gray300,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Decrement Button
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                child: FloatingActionButton(
                  heroTag: 'decrement_btn',
                  onPressed: _localValue > 0 ? _decrement : null,
                  backgroundColor: AppColors.primaryMedium,
                  foregroundColor: _localValue > 0
                      ? AppColors.primary
                      : AppColors.gray400,
                  elevation: 0,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: _localValue > 0
                          ? AppColors.primary
                          : AppColors.primaryDarkAccent,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.remove),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              // Input Field
              SizedBox(
                width: 120, // Mantendo a largura menor
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _onInputSubmitted(_controller.text);
                    }
                  },
                  child: CustomTextField(
                    label: 'PÁGINA ATUAL',
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              // Increment Button
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                child: FloatingActionButton(
                  heroTag: 'increment_btn',
                  onPressed: _localValue < widget.maxValue ? _increment : null,
                  backgroundColor: _localValue < widget.maxValue
                      ? AppColors.primary
                      : AppColors.primaryDarkAccent,
                  foregroundColor: AppColors.light,
                  elevation: 2,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
        ],
      ),
    );
  }
}
