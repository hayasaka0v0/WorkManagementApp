import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
import 'package:learning/features/task/presentation/widgets/priority_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (task.companyName != null) ...[
                      const Icon(
                        Icons.business_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.companyName!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getVisibilityColor(
                          task.visibility,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getVisibilityIcon(task.visibility),
                            size: 12,
                            color: _getVisibilityColor(task.visibility),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatVisibility(task.visibility),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getVisibilityColor(task.visibility),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2024),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sử dụng Widget đã tách riêng
                    PriorityBadge(priority: task.priority),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatStatus(task.status),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Due Date : ${_formatDate(task.dueDate)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Upcoming';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  String _formatVisibility(TaskVisibility visibility) {
    switch (visibility) {
      case TaskVisibility.public:
        return 'Public';
      case TaskVisibility.private:
        return 'Private';
      case TaskVisibility.teamOnly:
        return 'Team Only';
    }
  }

  IconData _getVisibilityIcon(TaskVisibility visibility) {
    switch (visibility) {
      case TaskVisibility.public:
        return Icons.public;
      case TaskVisibility.private:
        return Icons.lock_outline;
      case TaskVisibility.teamOnly:
        return Icons.group_outlined;
    }
  }

  Color _getVisibilityColor(TaskVisibility visibility) {
    switch (visibility) {
      case TaskVisibility.public:
        return Colors.green;
      case TaskVisibility.private:
        return Colors.red;
      case TaskVisibility.teamOnly:
        return Colors.blue;
    }
  }
}
