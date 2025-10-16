import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_text_style.dart';

class AppInputAtom extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const AppInputAtom({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<AppInputAtom> createState() => _AppInputAtomState();
}

class _AppInputAtomState extends State<AppInputAtom> {
  late final FocusNode _internalFocusNode;
  late bool _hasFocus;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _hasFocus = false;
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) return;
    final isNowFocused = _focusNode.hasFocus;
    if (isNowFocused != _hasFocus) {
      setState(() => _hasFocus = isNowFocused);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 380;
    final isTablet = width > 600;

    final double borderRadius = isTablet
        ? AppRadius.lg
        : (isSmall ? AppRadius.sm : AppRadius.md);
    final double verticalPadding = isSmall ? AppSpacing.sm : AppSpacing.md - 2;
    final double horizontalPadding = isSmall
        ? AppSpacing.sm + 4
        : AppSpacing.md;

    final textStyle = AppTextStyle.body(context);

    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: _hasFocus
            ? colorScheme.primary
            : colorScheme.outline.withOpacity(0.4),
        width: _hasFocus ? 1.6 : 1.1,
      ),
    );

    final fillColor = widget.enabled
        ? colorScheme.surface.withOpacity(0.04)
        : theme.disabledColor.withOpacity(0.05);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      decoration: _hasFocus
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : const BoxDecoration(),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        style: textStyle,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, size: isSmall ? 18 : 20)
              : null,
          filled: true,
          fillColor: fillColor,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
        ),
      ),
    );
  }
}
