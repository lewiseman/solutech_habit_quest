import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

typedef CustomAppDialog = Widget Function(
  ThemeData theme,
  Size size,
);

class AppDialog {
  static Future<dynamic> alert(
    BuildContext context, {
    String? title,
    String? message,
  }) {
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
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: title != null
              ? Text(
                  title,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium!.color,
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
                    color: theme.textTheme.bodyMedium!.color,
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
              child: Text(
                'CONFIRM',
                style: TextStyle(
                  fontFamily: AppTheme.poppinsFont,
                  color: theme.textTheme.bodyMedium!.color,
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
  Future<dynamic> showInfoLoad([String? message]) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Material(
                  borderRadius: BorderRadius.circular(6),
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

Widget emptyBanana({String? message, VoidCallback? onRetry}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/banana/box.png',
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
            textAlign: TextAlign.center,
          ),
        if (onRetry != null) const SizedBox(height: 10),
        if (onRetry != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRetry,
          ),
      ],
    ),
  );
}
