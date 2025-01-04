import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

typedef CustomAppDialog = Widget Function(
  ThemeData theme,
  Size size,
);

class AppDialog {
  static Future alert(BuildContext context, {String? title, String? message}) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != null
              ? Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                )
              : null,
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
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.poppinsFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              : null,
          content: message != null
              ? Text(
                  message,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppTheme.poppinsFont,
                  ),
                )
              : null,
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontFamily: AppTheme.poppinsFont,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'CONFIRM',
                style: TextStyle(
                  fontFamily: AppTheme.poppinsFont,
                ),
              ),
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
            child: LayoutBuilder(
              builder: (context, cs) {
                return builder(theme, cs.biggest);
              },
            ),
          ),
        );
      },
    );
  }
}

extension PlaceholderExt on BuildContext {
  Future showInfoLoad([String? message]) {
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
                      if (message != null)
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(
                              fontFamily: AppTheme.poppinsFont,
                            ),
                          ),
                        ),
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessToast(
    String message,
  ) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorToast(
    String message,
  ) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Widget bananaSearch({String? message}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/banana/search.png',
          width: 100,
          height: 100,
        ),
        if (message != null) const SizedBox(height: 6),
        if (message != null)
          Text(
            '    $message',
            style: const TextStyle(
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
        const SizedBox(height: 20),
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeCap: StrokeCap.round,
          ),
        ),
      ],
    ),
  );
}

Widget emptyBanana({String? message}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/banana/search.png',
          width: 100,
          height: 100,
        ),
        if (message != null) const SizedBox(height: 8),
        if (message != null)
          Text(
            message,
            style: const TextStyle(
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
      ],
    ),
  );
}
