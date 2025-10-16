import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_radius.dart';

class AppLoaderAtom extends StatefulWidget {
  final String? message;

  const AppLoaderAtom({super.key, this.message});

  @override
  State<AppLoaderAtom> createState() => _AppLoaderAtomState();
}

class _AppLoaderAtomState extends State<AppLoaderAtom>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _rotationController;
  late final AnimationController _bounceController;
  late final AnimationController _pulseController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.85,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                _rotationController,
                _bounceController,
                _pulseController,
              ]),
              builder: (_, __) {
                final rotation = _rotationController.value * 2 * math.pi;
                final bounce = math.sin(_bounceController.value * math.pi) * 6;
                final pulse = _pulseController.value;

                return Transform.translate(
                  offset: Offset(0, bounce),
                  child: Transform.rotate(
                    angle: rotation,
                    child: _buildPokeBall(theme, pulse),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            if (widget.message != null)
              Text(
                widget.message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.6,
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            const _AnimatedDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildPokeBall(ThemeData theme, double pulse) {
    return Container(
      width: 72 * pulse,
      height: 72 * pulse,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.25),
            blurRadius: 12 * pulse,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 36,
                  color: theme.colorScheme.primary.withOpacity(0.9),
                ),
              ),
            ),
          ),

          Container(
            height: 6,
            width: double.infinity,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),

          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.onSurface, width: 3),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDots extends StatefulWidget {
  const _AnimatedDots();

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = (3 * _dotsController.value).floor() + 1;
    return Text(
      'Cazando Pokémon${'.' * count}',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }
}
