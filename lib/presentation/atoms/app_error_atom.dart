import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_radius.dart';
import 'app_button_atom.dart';

class AppErrorAtom extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;
  final String buttonText;

  const AppErrorAtom({
    super.key,
    required this.message,
    required this.onRetry,
    this.buttonText = 'Reintentar',
  });

  @override
  State<AppErrorAtom> createState() => _AppErrorAtomState();
}

class _AppErrorAtomState extends State<AppErrorAtom>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _shakeController;
  late final AnimationController _pulseController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.85,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([
                  _shakeController,
                  _pulseController,
                ]),
                builder: (_, __) {
                  final shake =
                      math.sin(_shakeController.value * math.pi * 8) * 4;
                  final pulse = _pulseController.value;

                  return Transform.translate(
                    offset: Offset(shake, 0),
                    child: Transform.scale(
                      scale: pulse,
                      child: _buildBrokenPokeBall(theme),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '¡Ups! No se pudo atrapar el Pokémon',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButtonAtom(
                label: widget.buttonText,
                icon: Icons.refresh,
                type: AppButtonType.primary,
                onPressed: widget.onRetry,
                fullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrokenPokeBall(ThemeData theme) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 4,
            child: Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),

          Transform.rotate(
            angle: -0.1,
            child: Container(
              width: 72,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.full),
                ),
                border: Border.all(
                  color: theme.colorScheme.onSurface,
                  width: 3,
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.05,
            child: Container(
              width: 72,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.full),
                ),
                border: Border.all(
                  color: theme.colorScheme.onSurface,
                  width: 3,
                ),
              ),
            ),
          ),

          Container(
            height: 6,
            width: 70,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),

          CustomPaint(
            size: const Size(40, 40),
            painter: _CrackPainter(theme.colorScheme.onSurface),
          ),

          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.onSurface, width: 3),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrackPainter extends CustomPainter {
  final Color color;

  _CrackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.1)
      ..lineTo(size.width * 0.4, size.height * 0.3)
      ..lineTo(size.width * 0.55, size.height * 0.45)
      ..lineTo(size.width * 0.45, size.height * 0.6)
      ..lineTo(size.width * 0.5, size.height * 0.9);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CrackPainter oldDelegate) => false;
}
