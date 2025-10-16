import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/preference_cubit/preference_cubit.dart';
import '../../../logic/preference_cubit/preference_state.dart';

class DialogUtils {
  DialogUtils._();

  static bool validatePreferenceName(BuildContext context, String name) {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    if (name.trim().isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Por favor ingresa un nombre personalizado'),
          backgroundColor: Colors.red.shade400.withOpacity(0.95),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
      return false;
    }
    return true;
  }

  static bool isDuplicatePreference(
    BuildContext context,
    String apiUrl,
    String apiName,
  ) {
    final state = context.read<PreferenceCubit>().state;
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    if (state is PreferenceLoaded &&
        state.preferences.any(
          (p) => p.apiUrl == apiUrl || p.apiName == apiName,
        )) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('"$apiName" ya está en tus preferencias'),
          backgroundColor: Colors.red.shade400.withOpacity(0.95),

          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
      return true;
    }
    return false;
  }

  static void safeSnack(
    BuildContext context,
    String message, {
    Color? color,
    int seconds = 2,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final theme = Theme.of(context);

    Future.microtask(() {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor:
              color ?? theme.colorScheme.primaryContainer.withOpacity(0.95),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: seconds),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
    });
  }
}
