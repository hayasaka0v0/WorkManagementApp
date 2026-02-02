import 'package:learning/features/task/data/models/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> createTask({
    required String title,
    required String description,
    String? companyId,
    required String priority,
    required String status,
    required String visibility,
    required DateTime dueDate,
    String? assigneeId,
  });
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final SupabaseClient client;
  TaskRemoteDataSourceImpl(this.client);
  static const String _tableName = 'tasks';

  // Query string để join bảng users 2 lần:
  // 1. Lấy thông tin người tạo (creator) dựa trên creator_id
  // 2. Lấy thông tin người được giao (assignee) dựa trên assignee_id
  // Cú pháp 'users!creator_id' ám chỉ foreign key column.
  static const String _queryWithProfiles =
      '*, creator:users!creator_id(*), assignee:users!assignee_id(*), company:companies!company_id(*)';
  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Fetch user's company_id
      final userResponse = await client
          .from('users')
          .select('company_id')
          .eq('id', userId)
          .single();
      final String? companyId = userResponse['company_id'] as String?;

      var query = client.from(_tableName).select(_queryWithProfiles);

      if (companyId != null) {
        // Condition: (creator_id == me) OR (company_id == my_company AND visibility != private)
        // Note: For OR filters involving AND, we use the syntax: condition1,and(condition2,condition3)
        query = query.or(
          'creator_id.eq.$userId,and(company_id.eq.$companyId,visibility.neq.private)',
        );
      } else {
        // User is not in a company: Only see tasks they created.
        query = query.eq('creator_id', userId);
      }

      final response = await query.order('created_at', ascending: false);

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
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Fetch user's company_id
      final userResponse = await client
          .from('users')
          .select('company_id')
          .eq('id', userId)
          .single();
      final String? companyId = userResponse['company_id'] as String?;

      var query = client
          .from(_tableName)
          .select(_queryWithProfiles)
          .eq('id', id);

      if (companyId != null) {
        // Condition: (creator_id == me) OR (company_id == my_company AND visibility != private)
        query = query.or(
          'creator_id.eq.$userId,and(company_id.eq.$companyId,visibility.neq.private)',
        );
      } else {
        // User is not in a company: Only see tasks they created.
        query = query.eq('creator_id', userId);
      }

      final response = await query.single();
      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  @override
  Future<TaskModel> createTask({
    required String title,
    required String description,
    String? companyId,
    required String priority,
    required String status,
    required String visibility,
    required DateTime dueDate,
    String? assigneeId,
  }) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      final now = DateTime.now();

      // Chúng ta insert dữ liệu raw.
      // TaskModel sẽ được parse từ response trả về (đã join user).
      // Lưu ý: response của insert có thể chưa có join data ngay nếu không select đúng cách.
      // Cách an toàn nhất với Supabase là insert -> lấy ID -> fetch lại với đầy đủ join.

      final insertResponse = await client
          .from(_tableName)
          .insert({
            'title': title,
            'description': description,
            if (companyId != null) 'company_id': companyId,
            'creator_id': userId,
            'assignee_id': assigneeId,
            'priority': priority,
            'status': status,
            'visibility': visibility,
            'due_date': dueDate.toIso8601String(),
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select('id') // Chỉ cần lấy ID để query lại
          .single();

      // Fetch lại để có đầy đủ thông tin User (creator, assignee)
      return await getTaskById(insertResponse['id']);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      // Dùng toJson() của model để lấy map data cần update
      final taskData = task.toJson();

      // Loại bỏ các trường không nên update trực tiếp hoặc read-only nếu cần
      // Nhưng đơn giản nhất là update các trường chính.
      // Supabase sẽ ignore các field không có trong table nếu ta config filter,
      // nhưng tốt nhất là chỉ gửi các field thay đổi.
      // Ở đây ta gửi full object update đè lên.

      await client
          .from(_tableName)
          .update({
            'title': task.title,
            'description': task.description,
            'status': taskData['status'], // Lấy string từ toJson
            'priority': taskData['priority'],
            'visibility': taskData['visibility'],
            'assignee_id': task.assignee?.id,
            'due_date': task.dueDate.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', task.id);
      // Fetch lại để đảm bảo data đồng bộ nhất
      return await getTaskById(task.id);
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
