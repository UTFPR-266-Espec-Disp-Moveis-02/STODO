import 'package:flutter/material.dart';

class AnimatedGridView extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const AnimatedGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.85,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
  });

  @override
  State<AnimatedGridView> createState() => _AnimatedGridViewState();
}

class _AnimatedGridViewState extends State<AnimatedGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // A duração total depende da quantidade de itens.
    // 400ms base de duração por item, e cada item é atrasado 100ms.
    final totalDuration = 400 + (widget.children.length * 100);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalDuration),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      final totalDuration = 400 + (widget.children.length * 100);
      _controller.duration = Duration(milliseconds: totalDuration);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
      ),
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        // Calcula o intervalo de tempo específico deste card aparecer
        final totalDuration = 400 + (widget.children.length * 100);
        final start = (index * 100) / totalDuration;
        final end = ((index * 100) + 400) / totalDuration;

        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(
                  0,
                  50 * (1 - animation.value),
                ), // Efeito de subida
                child: child,
              ),
            );
          },
          child: widget.children[index],
        );
      },
    );
  }
}
