import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
import 'package:learning/features/task/presentation/bloc/task_bloc.dart';

class CreateTaskDialog extends StatefulWidget {
  final Task? task; // If provided, we are in Edit mode

  const CreateTaskDialog({super.key, this.task});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late TaskPriority _selectedPriority;
  late TaskStatus _selectedStatus;
  late TaskVisibility _selectedVisibility;

  // UI Loading state local to dialog
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Init values
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedDate =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedStatus = widget.task?.status ?? TaskStatus.pending;
    _selectedVisibility = widget.task?.visibility ?? TaskVisibility.teamOnly;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.task != null;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditing ? 'Edit Task' : 'Create New Task',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2024),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Task Title
                _buildLabel('Task Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration('Enter Task Title'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),

                // Description
                _buildLabel('Description (Optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration('Enter task description...'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Due Date
                _buildLabel('Due Date'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('MMM d, yyyy').format(_selectedDate),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Priority
                _buildLabel('Priority'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TaskPriority>(
                      value: _selectedPriority,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[500],
                      ),
                      items: TaskPriority.values.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(
                            p.name[0].toUpperCase() + p.name.substring(1),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedPriority = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Status (Only show if editing or advanced mode, but per design let's show it)
                _buildLabel('Status'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TaskStatus>(
                      value: _selectedStatus,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[500],
                      ),
                      items: TaskStatus.values.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(
                            _formatStatus(s),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStatus = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Visibility
                _buildLabel('Visibility'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TaskVisibility>(
                      value: _selectedVisibility,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[500],
                      ),
                      items: TaskVisibility.values.map((v) {
                        return DropdownMenuItem(
                          value: v,
                          child: Text(
                            _formatVisibility(v),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedVisibility = val);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.grey[700],
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E88FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isEditing ? 'Update Task' : 'Create Task',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2024),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2E88FF)),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatStatus(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending:
        return 'Upcoming';
      case TaskStatus.inProgress:
        return 'In Process';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatVisibility(TaskVisibility v) {
    switch (v) {
      case TaskVisibility.public:
        return 'Public';
      case TaskVisibility.private:
        return 'Private';
      case TaskVisibility.teamOnly:
        return 'Team Only';
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();

    // Use context.read to access the Bloc provided by the parent dialog route
    final bloc = context.read<TaskBloc>();

    // Get current user to get companyId
    final authState = context.read<AuthBloc>().state;
    String companyId;

    if (authState is AuthAuthenticated) {
      // Allow creation without companyId (Personal Task)
      companyId = authState.user.companyId ?? '';

      // If no company, force visibility to private (optional logic, but good for safety)
      if (companyId.isEmpty) {
        if (_selectedVisibility != TaskVisibility.private) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Personal tasks must be Private. Visibility adjusted.',
              ),
              duration: Duration(seconds: 2),
            ),
          );
          _selectedVisibility = TaskVisibility.private;
        }
      }
    } else {
      // Should handle unauthenticated state, though typically not reachable here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not authenticated')),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (_isEditing) {
      final updatedTask = widget.task!.copyWith(
        title: title,
        description: desc,
        dueDate: _selectedDate,
        priority: _selectedPriority,
        status: _selectedStatus,
        visibility: _selectedVisibility,
      );
      bloc.add(UpdateTaskEvent(updatedTask));
    } else {
      bloc.add(
        CreateTaskEvent(
          title: title,
          description: desc,
          companyId: companyId.isEmpty ? null : companyId,
          priority: _selectedPriority,
          status: _selectedStatus,
          visibility: _selectedVisibility,
          dueDate: _selectedDate,
        ),
      );
    }

    // Simulate delay or listen to bloc state (optional improvement: use BlocListener inside Dialog)
    // For now, close after short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) Navigator.pop(context);
    });
  }
}
