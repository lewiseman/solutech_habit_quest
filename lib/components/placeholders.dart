import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

typedef CustomAppDialog = Widget Function(
  ThemeData theme,
  Size size,
);

class AppDialog {
  static alert(BuildContext context, {String? title, String? message}) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: message != null ? Text(message) : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> confirm(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: title != null
              ? Text(
                  title,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                )
              : null,
          content: message != null
              ? Text(
                  message,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                )
              : null,
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'CANCEL',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('CONFIRM'),
            ),
          ],
        );
      },
    );
  }

  static Future<T?> custom<T>(
    BuildContext context, {
    required CustomAppDialog builder,
  }) {
    final theme = Theme.of(context);
    return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(builder: (context, cs) {
              return builder(theme, cs.biggest);
            }),
          ),
        );
      },
    );
  }
}

extension PlaceholderExt on BuildContext {
  showInfoLoad([String? message]) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      if (message != null) const SizedBox(width: 20),
                      if (message != null) Expanded(child: Text(message)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
