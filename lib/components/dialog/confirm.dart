import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? cancelText;
  final String? confirmText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText,
    this.confirmText,
  });

  static Future<bool?> show(BuildContext context,
      {required String title,
      required String content,
      String? cancelText,
      String? confirmText}) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: title,
            content: content,
            cancelText: cancelText,
            confirmText: confirmText,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (cancelText != null && cancelText!.isNotEmpty) {
      actions.add(TextButton(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(color: Colors.red)),
          child: Text(cancelText!),
          onPressed: () {
            Navigator.of(context).pop(false);
          }));
    }
    if (confirmText != null && confirmText!.isNotEmpty) {
      actions.add(TextButton(
          child: Text(confirmText!),
          onPressed: () {
            Navigator.of(context).pop(true);
          }));
    }
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions,
    );
  }
}
