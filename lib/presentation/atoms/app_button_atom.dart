import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_text_style.dart';

enum AppButtonType { primary, secondary, text }

class AppButtonAtom extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonType type;
  final IconData? icon;
  final Color? color;
  final bool fullWidth;
  final bool isLoading;

  const AppButtonAtom({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.color,
    this.fullWidth = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? theme.colorScheme.primary;
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 380;
    final isTablet = width > 600;

    final EdgeInsetsGeometry basePadding = EdgeInsets.symmetric(
      horizontal: isTablet
          ? AppSpacing.lg
          : (isSmall ? AppSpacing.sm + 4 : AppSpacing.md + 6),
      vertical: isSmall ? AppSpacing.sm : AppSpacing.md - 4,
    );

    final content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeOutCubic,
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: isLoading
          ? _buildLoader(baseColor)
          : _buildLabel(context, baseColor, isSmall),
    );

    final style = _buildStyle(context, baseColor, basePadding);

    final button = switch (type) {
      AppButtonType.secondary => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: content,
      ),
      AppButtonType.text => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: content,
      ),
      _ => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: content,
      ),
    };

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildLoader(Color baseColor) => SizedBox(
    key: const ValueKey('loader'),
    height: 22,
    width: 22,
    child: CircularProgressIndicator(
      strokeWidth: 2.3,
      valueColor: AlwaysStoppedAnimation<Color>(baseColor),
    ),
  );

  Widget _buildLabel(BuildContext context, Color baseColor, bool isSmall) =>
      Row(
        key: const ValueKey('label'),
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 16 : 18),
            const SizedBox(width: AppSpacing.sm - 2),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.body(context, bold: true).copyWith(
                color: type == AppButtonType.text ? baseColor : Colors.white,
              ),
            ),
          ),
        ],
      );

  ButtonStyle _buildStyle(
    BuildContext context,
    Color baseColor,
    EdgeInsetsGeometry padding,
  ) {
    final theme = Theme.of(context);

    return switch (type) {
      AppButtonType.secondary => OutlinedButton.styleFrom(
        side: BorderSide(color: baseColor, width: 1.3),
        foregroundColor: baseColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      AppButtonType.text => TextButton.styleFrom(
        foregroundColor: baseColor,
        overlayColor: baseColor.withOpacity(0.08),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm - 2,
        ),
        textStyle: AppTextStyle.body(context, bold: true),
      ),
      _ => ElevatedButton.styleFrom(
        backgroundColor: baseColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: theme.disabledColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        textStyle: AppTextStyle.body(context, bold: true),
      ),
    };
  }
}
