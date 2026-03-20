import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stodo/core/themes/theme_exports.dart';

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
            children: [
              // Decrement Button
              InkWell(
                onTap: _localValue > 0 ? _decrement : null,
                borderRadius: BorderRadius.circular(AppSpacing.s32),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryDarkAccent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: _localValue > 0
                        ? AppColors.primary
                        : AppColors.gray400,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              // Input Field
              Container(
                width: 120,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(AppSpacing.s16),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.light,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: _onInputSubmitted,
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _onInputSubmitted(_controller.text);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              // Increment Button
              InkWell(
                onTap: _localValue < widget.maxValue ? _increment : null,
                borderRadius: BorderRadius.circular(AppSpacing.s32),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _localValue < widget.maxValue
                        ? AppColors.primary
                        : AppColors.primaryDarkAccent,
                  ),
                  child: Icon(
                    Icons.add,
                    color: _localValue < widget.maxValue
                        ? AppColors.light
                        : AppColors.gray400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'PÁGINA ATUAL',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.gray300,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
