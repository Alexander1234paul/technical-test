import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_text_style.dart';
import 'app_button_atom.dart';

class CustomDialogAtom {
  static Future<void> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Aceptar',
    String cancelText = 'Cancelar',
    Color confirmColor = Colors.redAccent,
    bool showCancel = true,
    IconData? icon,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Icon(icon, color: confirmColor, size: 24),
              ),
            Expanded(child: Text(title, style: AppTextStyle.title(ctx))),
          ],
        ),
        content: Text(message, style: AppTextStyle.body(ctx)),
        actions: [
          if (showCancel)
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(cancelText),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required VoidCallback onConfirm,
    String confirmText = 'Guardar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
    bool showCancel = true,
    IconData? icon,
  }) {
    return showGeneralDialog(
      context: context,
      barrierLabel: 'Modal',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curved = Curves.easeOutBack.transform(anim1.value);
        return Transform.scale(
          scale: curved,
          child: Opacity(
            opacity: anim1.value,
            child: _CustomModalContent(
              title: title,
              content: content,
              onConfirm: onConfirm,
              confirmText: confirmText,
              cancelText: cancelText,
              confirmColor: confirmColor,
              showCancel: showCancel,
              icon: icon,
            ),
          ),
        );
      },
    );
  }
}

class _CustomModalContent extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color? confirmColor;
  final bool showCancel;
  final IconData? icon;

  const _CustomModalContent({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.confirmText,
    required this.cancelText,
    required this.confirmColor,
    required this.showCancel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final keyboardHeight = media.viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double topPadding = isKeyboardVisible
        ? AppSpacing.xl
        : screenHeight * 0.22;
    final double maxModalHeight = isKeyboardVisible
        ? screenHeight * 0.65
        : screenHeight * 0.5;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              top: topPadding,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: SafeArea(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(bottom: keyboardHeight),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: maxModalHeight,
                        minHeight: 120,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md + 4,
                          vertical: AppSpacing.md + 6,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (icon != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: AppSpacing.sm,
                                      ),
                                      child: Icon(
                                        icon,
                                        color:
                                            confirmColor ?? colorScheme.primary,
                                        size: 24,
                                      ),
                                    ),
                                  Flexible(
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.title(context),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md + 2),
                              content,
                              const SizedBox(height: AppSpacing.lg),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (showCancel)
                                    AppButtonAtom(
                                      label: cancelText,
                                      type: AppButtonType.text,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  const SizedBox(width: AppSpacing.sm),
                                  AppButtonAtom(
                                    label: confirmText,
                                    type: AppButtonType.primary,
                                    color: confirmColor ?? colorScheme.primary,
                                    onPressed: onConfirm,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
