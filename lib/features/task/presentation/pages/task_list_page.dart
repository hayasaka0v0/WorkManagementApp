import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/di/injection_container.dart';
import 'package:learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning/features/auth/presentation/pages/login_page.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
import 'package:learning/features/task/presentation/bloc/task_bloc.dart';
import 'package:learning/features/task/presentation/widgets/create_task_dialog.dart';
import 'package:learning/features/task/presentation/widgets/empty_tasks_widget.dart';
import 'package:learning/features/task/presentation/widgets/task_header.dart';
import 'package:learning/features/task/presentation/widgets/section_header.dart';
import 'package:learning/features/task/presentation/widgets/task_card.dart';
import 'package:learning/features/task/presentation/widgets/task_filter_tab.dart';

/// Task list page - displays dashboard
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TaskBloc>()..add(LoadTasksEvent()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  int _selectedTabIndex = 0; // 0: Active, 1: Completed

  @override
  Widget build(BuildContext context) {
    // Access auth state listener here
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else if (state is AuthAuthenticated) {
          // User profile updated (e.g. Joined/Left company), reload tasks
          // This ensures the task list reflects the new company context
          context.read<TaskBloc>().add(LoadTasksEvent());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: HomeHeader(),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Tasks',
                        action: IconButton(
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Colors.black54,
                          ),
                          onPressed: () => _showFilterDialog(context),
                        ),
                      ),
                    ),

                    // 4. Filter Tabs
                    SliverToBoxAdapter(
                      child: TaskFilterTab(
                        selectedIndex: _selectedTabIndex,
                        onTabChanged: (index) {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                      ),
                    ),

                    // 5. Task List
                    BlocBuilder<TaskBloc, TaskState>(
                      bloc: context.read<TaskBloc>(),
                      builder: (context, state) {
                        if (state is TaskLoading) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (state is TaskError) {
                          return SliverFillRemaining(
                            child: Center(child: Text(state.message)),
                          );
                        } else if (state is TaskLoaded) {
                          final filteredTasks = state.tasks.where((task) {
                            if (_selectedTabIndex == 0) {
                              return task.status == TaskStatus.pending ||
                                  task.status == TaskStatus.inProgress;
                            } else {
                              return task.status == TaskStatus.completed;
                            }
                          }).toList();

                          if (filteredTasks.isEmpty) {
                            return const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 200,
                                child: EmptyTasksWidget(),
                              ),
                            );
                          }

                          return SliverPadding(
                            padding: const EdgeInsets.only(bottom: 80),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return TaskCard(
                                  task: filteredTasks[index],
                                  onTap: () => _navigateToEditTask(
                                    context,
                                    filteredTasks[index],
                                  ),
                                );
                              }, childCount: filteredTasks.length),
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToCreateTask(context),
          backgroundColor: const Color(0xFF6B66FE),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    final authState = context.read<AuthBloc>().state;
    String? companyId;
    if (authState is AuthAuthenticated) {
      companyId = authState.user.companyId;
    }

    // Current filter values
    String? selectedCompanyFilter;
    List<TaskPriority> selectedPriorities = [];
    List<TaskVisibility> selectedVisibilities = [];

    if (taskBloc.state is TaskLoaded) {
      final state = taskBloc.state as TaskLoaded;
      selectedCompanyFilter = state.filterCompanyId;
      selectedPriorities = List.from(state.filterPriorities ?? []);
      selectedVisibilities = List.from(state.filterVisibilities ?? []);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Clear filters
                          setState(() {
                            selectedCompanyFilter = null;
                            selectedPriorities = [];
                            selectedVisibilities = [];
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Company Filter
                  if (companyId != null) ...[
                    const Text(
                      'Company',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All Tasks'),
                          selected: selectedCompanyFilter == null,
                          onSelected: (selected) {
                            if (selected)
                              setState(() => selectedCompanyFilter = null);
                          },
                        ),
                        ChoiceChip(
                          label: const Text('My Company'),
                          selected: selectedCompanyFilter == companyId,
                          onSelected: (selected) {
                            // Use companyId from closure
                            if (selected)
                              setState(() => selectedCompanyFilter = companyId);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Priority Filter
                  const Text(
                    'Priority',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: TaskPriority.values.map((priority) {
                      final isSelected = selectedPriorities.contains(priority);
                      return FilterChip(
                        label: Text(priority.name.toUpperCase()),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedPriorities.add(priority);
                            } else {
                              selectedPriorities.remove(priority);
                            }
                          });
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor: Colors.blue[100],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Visibility Filter
                  const Text(
                    'Visibility',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: TaskVisibility.values.map((visibility) {
                      final isSelected = selectedVisibilities.contains(
                        visibility,
                      );
                      return FilterChip(
                        label: Text(visibility.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedVisibilities.add(visibility);
                            } else {
                              selectedVisibilities.remove(visibility);
                            }
                          });
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor: Colors.purple[100],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        taskBloc.add(
                          FilterTasksEvent(
                            companyId: selectedCompanyFilter,
                            priorities: selectedPriorities.isEmpty
                                ? null
                                : selectedPriorities,
                            visibilities: selectedVisibilities.isEmpty
                                ? null
                                : selectedVisibilities,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B66FE),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToCreateTask(BuildContext context) {
    // Capture the current bloc instance
    final taskBloc = context.read<TaskBloc>();

    showDialog(
      context: context,
      builder: (_) =>
          BlocProvider.value(value: taskBloc, child: const CreateTaskDialog()),
    );
  }

  void _navigateToEditTask(BuildContext context, Task task) {
    // Capture the current bloc instance
    final taskBloc = context.read<TaskBloc>();

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: taskBloc,
        child: CreateTaskDialog(task: task),
      ),
    );
  }
}

void _dummyOnTap() {}
