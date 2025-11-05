import 'dart:math' as math;
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class LoadingDataWidget extends StatefulWidget {
  final String? message;
  final double size;
  final bool showPulse;

  const LoadingDataWidget({
    super.key,
    this.message,
    this.size = 60,
    this.showPulse = true,
  });

  @override
  State<LoadingDataWidget> createState() => _LoadingDataWidgetState();
}

class _LoadingDataWidgetState extends State<LoadingDataWidget>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated loading spinner
            AnimatedBuilder(
              animation: Listenable.merge([_spinController, _pulseController]),
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.showPulse ? _pulseAnimation.value : 1.0,
                  child: Transform.rotate(
                    angle: _spinController.value * 2 * math.pi,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            context.primaryColor.withOpacity(0.1),
                            context.primaryColor,
                            context.primaryColor,
                            context.primaryColor.withOpacity(0.1),
                          ],
                          stops: const [0.0, 0.5, 0.75, 1.0],
                          transform: const GradientRotation(math.pi / 4),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(widget.size * 0.15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.surfaceColor,
                        ),
                        child: Center(
                          child: Container(
                            width: widget.size * 0.3,
                            height: widget.size * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  context.primaryColor,
                                  context.primaryColor.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Loading message
            if (widget.message != null) ...[
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.5 + (_pulseAnimation.value - 0.85) * 0.5,
                    child: Text(
                      widget.message!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.primaryTextColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Compact version for inline loading states
class CompactLoadingWidget extends StatefulWidget {
  final double size;

  const CompactLoadingWidget({super.key, this.size = 24});

  @override
  State<CompactLoadingWidget> createState() => _CompactLoadingWidgetState();
}

class _CompactLoadingWidgetState extends State<CompactLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: context.primaryColor,
              backgroundColor: context.primaryColor.withOpacity(0.2),
            ),
          );
        },
      ),
    );
  }
}
