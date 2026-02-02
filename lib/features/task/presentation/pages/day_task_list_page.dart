import 'package:flutter/material.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
import 'package:learning/features/task/presentation/widgets/task_card.dart';
import 'package:intl/intl.dart';

class DayTaskListPage extends StatelessWidget {
  final DateTime date;
  final List<Task> tasks;

  const DayTaskListPage({super.key, required this.date, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Text(
          DateFormat('MMMM d, y').format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks for this day',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TaskCard(task: tasks[index]),
                );
              },
            ),
    );
  }
}
