import 'package:flutter/material.dart';
import '../../core/constants/app_radius.dart';

class PokeImageAtom extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final String heroTag;

  const PokeImageAtom({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 380;
    final bgColor = theme.colorScheme.surfaceVariant.withOpacity(0.5);

    final effectiveRadius = isSmall
        ? radius * 0.9
        : (media.size.width > 600 ? radius * 1.2 : radius);

    return Hero(
      tag: heroTag,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: effectiveRadius * 2,
          height: effectiveRadius * 2,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              width: effectiveRadius * 2,
              height: effectiveRadius * 2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: SizedBox(
                width: effectiveRadius * 0.8,
                height: effectiveRadius * 0.8,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            width: effectiveRadius * 2,
            height: effectiveRadius * 2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Icon(
              Icons.image_not_supported_outlined,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              size: effectiveRadius * 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
