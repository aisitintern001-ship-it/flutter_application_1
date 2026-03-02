import 'package:flutter/material.dart';

enum StatusType {
  approved,
  pending,
  declined,
}

class StatusPill extends StatelessWidget {
  final StatusType status;
  final int? count;
  final double fontSize;
  final EdgeInsets padding;

  const StatusPill({
    super.key,
    required this.status,
    this.count,
    this.fontSize = 13,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: config.color.withOpacity(.12), // 👈 soft background
        borderRadius: BorderRadius.circular(50), // 👈 capsule
        border: Border.all(
          // ignore: deprecated_member_use
          color: config.color.withOpacity(.35), // 👈 outline
          width: 1.4,
        ),
      ),
      child: Text(
        count != null
            ? '${config.label}: $count'
            : config.label,
        style: TextStyle(
          color: config.color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _StatusConfig _getConfig(StatusType status) {
    switch (status) {
      case StatusType.approved:
        return _StatusConfig("Approved", Colors.green);

      case StatusType.pending:
        return _StatusConfig("Pending", Colors.orange);

      case StatusType.declined:
        return _StatusConfig("Declined", Colors.red);
    }
  }
}

/// Only 1 color needed now
class _StatusConfig {
  final String label;
  final Color color;

  _StatusConfig(this.label, this.color);
}