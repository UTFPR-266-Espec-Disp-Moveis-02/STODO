import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stodo/core/themes/theme_exports.dart';
import 'package:stodo/core/image_picker/image_picker_service.dart';

class ImageUploadField extends StatefulWidget {
  final String label;
  final String? initialImagePath;
  final ValueChanged<String?>? onImageSelected;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const ImageUploadField({
    super.key,
    required this.label,
    this.initialImagePath,
    this.onImageSelected,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  String? _currentImagePath;
  final ImagePickerService _pickerService = ImagePickerService();
  bool _isLoading = false;
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.initialImagePath;
  }

  @override
  void didUpdateWidget(covariant ImageUploadField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialImagePath != oldWidget.initialImagePath) {
      _currentImagePath = widget.initialImagePath;
    }
  }

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    final String? imagePath = await _pickerService.pickImage();

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (imagePath != null) {
      setState(() => _currentImagePath = imagePath);
      _fieldKey.currentState?.didChange(imagePath);
      widget.onImageSelected?.call(imagePath);
    }
  }

  void _removeImage() {
    setState(() => _currentImagePath = null);
    _fieldKey.currentState?.didChange(null);
    widget.onImageSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: _fieldKey,
      initialValue: _currentImagePath,
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
            GestureDetector(
              onTap: _pickImage,
              child: _currentImagePath != null
                  ? _buildImagePreview()
                  : _buildUploadPlaceholder(hasError: state.hasError),
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

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.s16),
            border: Border.all(color: AppColors.primaryDarkAccent, width: 2),
            image: DecorationImage(
              image: FileImage(File(_currentImagePath!)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: AppSpacing.s12,
          right: AppSpacing.s12,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.s8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder({bool hasError = false}) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: hasError
            ? AppColors.topicColor2.withValues(alpha: 0.6)
            : AppColors.gray400.withValues(alpha: 0.5),
        strokeWidth: 2,
        radius: AppSpacing.s16,
        dashPattern: const [8, 4],
      ),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primaryMedium,
          borderRadius: BorderRadius.circular(AppSpacing.s16),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    'Upload de Capa',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.light,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    'Toque para selecionar uma imagem',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.gray300),
                  ),
                ],
              ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final List<double> dashPattern;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    final dashedPath = _dashPath(
      path,
      dashArray: CircularIntervalList<double>(dashPattern),
    );
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashPattern != dashPattern;
  }

  Path _dashPath(
    Path source, {
    required CircularIntervalList<double> dashArray,
  }) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = dashArray.next;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }
}

class CircularIntervalList<T> {
  CircularIntervalList(this._vals);
  final List<T> _vals;
  int _idx = 0;
  T get next {
    if (_idx >= _vals.length) {
      _idx = 0;
    }
    return _vals[_idx++];
  }
}
