import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../theme/theme.dart';

class UnavailableItemDialog extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const UnavailableItemDialog({
    Key? key,
    required this.message,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).error,
        style: TextStyle(
          color: buttonAccentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          style: TextButton.styleFrom(
            backgroundColor: buttonAccentColor,
            foregroundColor: Colors.white,
          ),
          child: Text(S.of(context).okButtonLabel),
        ),
      ],
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: buttonAccentColor),
      ),
    );
  }
}