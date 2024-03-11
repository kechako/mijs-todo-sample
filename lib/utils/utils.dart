import 'package:flutter/material.dart';

Future<T> doProgress<T>(BuildContext context, Future<T> Function() task) async {
  showProgressDialog(context);

  try {
    final result = await task();
    return result;
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: false).pop();
    }
  }
}

void showProgressDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    barrierDismissible: false,
    useRootNavigator: false,
  );
}

void showErrorSnackBar(BuildContext context, String errorMessage) {
  final snackBar = SnackBar(
    content: Text(errorMessage,
        style: TextStyle(color: Theme.of(context).colorScheme.error)),
    backgroundColor: Theme.of(context).colorScheme.errorContainer,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
