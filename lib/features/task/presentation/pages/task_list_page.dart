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
        child: Scaffold(appBar: AppBar()),
      ),
    );
  }
}
