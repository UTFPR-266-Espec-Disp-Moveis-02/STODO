import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';
import 'package:stodo/core/utils/input_formatters.dart';
import 'package:stodo/core/utils/validators.dart';

import 'custom_text_field.dart';

/// Componente para rastrear o progresso e atualizar rapidamente as páginas de um livro lido.
///
/// Este widget exibe botões rápidos de `+1` ou `-1` página, além de permitir o
/// preenchimento manual massivo através de um dropdown numérico ([CustomTextField]).
/// Um dos core features do STODO na melhoria do input de leitura.
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
  final _formKey = GlobalKey<FormState>();

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

  /// Atualiza o display em tempo real conforme o usuário digita.
  void _onTyped(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      setState(() => _localValue = parsed);
    }
  }

  /// Chamado ao perder o foco — clampeia e emite o valor final.
  void _onInputSubmitted(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      final clamped = parsed.clamp(0, widget.maxValue);
      setState(() {
        _localValue = clamped;
        _controller.text = _localValue.toString();
      });
      widget.onChanged(_localValue);
    } else {
      _controller.text = _localValue.toString();
    }
    _formKey.currentState?.validate();
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
              FloatingActionButton(
                heroTag: null,
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
              const SizedBox(width: AppSpacing.s16),
              // Input Field
              SizedBox(
                width: 120,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) _onInputSubmitted(_controller.text);
                    },
                    child: CustomTextField(
                      label: 'PÁGINA ATUAL',
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [AppInputFormatters.digitsOnly],
                      onChanged: _onTyped,
                      validator: AppValidators.pageNumber(max: widget.maxValue),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              // Increment Button
              FloatingActionButton(
                heroTag: null,
                onPressed: _localValue < widget.maxValue ? _increment : null,
                backgroundColor: _localValue < widget.maxValue
                    ? AppColors.primary
                    : AppColors.primaryDarkAccent,
                foregroundColor: AppColors.light,
                elevation: 2,
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
        ],
      ),
    );
  }
}
