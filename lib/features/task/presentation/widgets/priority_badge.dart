import 'package:flutter/material.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (priority) {
      case TaskPriority.high:
      case TaskPriority.urgent:
        bgColor = const Color(0xFFFFF9EC);
        textColor = const Color(0xFFF4B846);
        label = 'High';
        break;
      case TaskPriority.medium:
        bgColor = const Color(0xFFEBF6FF);
        textColor = const Color(0xFF4C9EEB);
        label = 'Medium';
        break;
      case TaskPriority.low:
        bgColor = const Color(0xFFE8FDF2);
        textColor = const Color(0xFF26B676);
        label = 'Low';
        break;
    }

    if (priority == TaskPriority.urgent) {
      label = 'Urgent';
      bgColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
