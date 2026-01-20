import 'package:flutter/material.dart';

/// Widget displayed when there are no tasks
class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first task',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
