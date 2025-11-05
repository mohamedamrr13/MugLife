import 'package:flutter/material.dart';

class NabBarIcon extends StatefulWidget {
  const NabBarIcon({
    super.key,
    required this.iconData,
    required this.pageIndex,
    required this.isActive,
    this.onPressed,
  });

  final IconData iconData;
  final int pageIndex;
  final bool isActive;
  final void Function()? onPressed;

  @override
  State<NabBarIcon> createState() => _NabBarIconState();
}

class _NabBarIconState extends State<NabBarIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(NabBarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  widget.isActive
                      ? colorScheme.primary.withOpacity(0.15)
                      : Colors.transparent,
                ),
                overlayColor: WidgetStateProperty.all(
                  colorScheme.primary.withOpacity(0.1),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    side: widget.isActive
                        ? BorderSide(
                            color: colorScheme.primary.withOpacity(0.3),
                            width: 1.5,
                          )
                        : BorderSide.none,
                  ),
                ),
              ),
              onPressed: widget.onPressed,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.iconData,
                    size: 26,
                    color: widget.isActive
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 3,
                    width: widget.isActive ? 20 : 0,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
