import 'package:learning/features/task/data/models/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract interface for task remote data source
abstract interface class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> createTask({
    required String title,
    required String description,
  });
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

/// Implementation of TaskRemoteDataSource using Supabase
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final SupabaseClient client;

  TaskRemoteDataSourceImpl(this.client);

  static const String _tableName = 'tasks';

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  @override
  Future<TaskModel> createTask({
    required String title,
    required String description,
  }) async {
    try {
      // Get current user ID
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();

      final response = await client
          .from(_tableName)
          .insert({
            'title': title,
            'description': description,
            'is_completed': false,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
            'user_id': userId,
          })
          .select()
          .single();

      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final now = DateTime.now();

      final response = await client
          .from(_tableName)
          .update({
            'title': task.title,
            'description': task.description,
            'is_completed': task.isCompleted,
            'updated_at': now.toIso8601String(),
          })
          .eq('id', task.id)
          .select()
          .single();

      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
