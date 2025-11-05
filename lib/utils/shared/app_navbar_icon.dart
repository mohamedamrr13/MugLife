import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class NabBarIcon extends StatefulWidget {
  const NabBarIcon({
    super.key,
    required this.iconData,
    required this.pageIndex,
    required this.isSelected,
    this.onPressed,
  });

  final IconData iconData;
  final int pageIndex;
  final bool isSelected;
  final void Function()? onPressed;

  @override
  State<NabBarIcon> createState() => _NabBarIconState();
}

class _NabBarIconState extends State<NabBarIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(NabBarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: widget.isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.primaryColor.withOpacity(0.3),
                            context.primaryColor.withOpacity(0.15),
                          ],
                        )
                      : null,
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: context.primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated background indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: widget.isSelected ? 50 : 0,
                      height: widget.isSelected ? 50 : 0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.primaryColor.withOpacity(0.2),
                      ),
                    ),
                    // Icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        widget.iconData,
                        size: widget.isSelected ? 28 : 24,
                        color: widget.isSelected
                            ? context.primaryColor
                            : context.secondaryTextColor.withOpacity(0.7),
                      ),
                    ),
                    // Selection indicator dot
                    if (widget.isSelected)
                      Positioned(
                        bottom: 6,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: context.primaryColor.withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
