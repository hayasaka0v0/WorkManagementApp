import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/di/injection_container.dart';
import 'package:learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning/features/auth/presentation/pages/login_page.dart';
import 'package:learning/features/task/presentation/bloc/task_bloc.dart';
import 'package:learning/features/task/presentation/pages/task_form_page.dart';
import 'package:learning/features/task/presentation/widgets/empty_tasks_widget.dart';
import 'package:learning/features/task/presentation/widgets/task_card.dart';

/// Task list page - displays all tasks
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TaskBloc>()..add(LoadTasksEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // Navigate to login page when user logs out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Tasks'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ],
          ),
          body: BlocConsumer<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TaskLoaded) {
                if (state.tasks.isEmpty) {
                  return const EmptyTasksWidget();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<TaskBloc>().add(LoadTasksEvent());
                    // Wait a bit for the refresh to complete
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskCard(
                        task: task,
                        onToggle: () {
                          context.read<TaskBloc>().add(
                            ToggleTaskCompletionEvent(task.id),
                          );
                        },
                        onDelete: () {
                          context.read<TaskBloc>().add(
                            DeleteTaskEvent(task.id),
                          );
                        },
                        onTap: () {
                          final bloc = context.read<TaskBloc>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: bloc,
                                child: TaskFormPage(task: task, bloc: bloc),
                              ),
                            ),
                          ).then((_) {
                            // Reload tasks when returning from edit page
                            bloc.add(LoadTasksEvent());
                          });
                        },
                      );
                    },
                  ),
                );
              }

              return const EmptyTasksWidget();
            },
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  final bloc = context.read<TaskBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: bloc,
                        child: TaskFormPage(bloc: bloc),
                      ),
                    ),
                  ).then((_) {
                    // Reload tasks when returning from create page
                    bloc.add(LoadTasksEvent());
                  });
                },
                child: const Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}
