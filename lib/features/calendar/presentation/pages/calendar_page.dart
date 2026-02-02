import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/di/injection_container.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
import 'package:learning/features/task/presentation/bloc/task_bloc.dart';
import 'package:learning/features/task/presentation/pages/day_task_list_page.dart';
import 'package:table_calendar/table_calendar.dart';

// Import widget files
import '../widgets/custom_day_cell.dart';
import '../widgets/month_selector.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TaskBloc>()..add(LoadTasksEvent()),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView();

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Map<DateTime, List<Task>> _events = {};

  // Group tasks by Date and Sort by Priority
  Map<DateTime, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final Map<DateTime, List<Task>> data = {};
    for (var task in tasks) {
      final date = DateTime.utc(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );
      if (data[date] == null) data[date] = [];
      data[date]!.add(task);
    }

    // Sort tasks in each day: Urgent > High > Medium > Low
    // TaskPriority values: low (0), medium (1), high (2), urgent (3)
    data.forEach((key, value) {
      value.sort((a, b) {
        return b.priority.index.compareTo(a.priority.index);
      });
    });

    return data;
  }

  List<Task> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  // Helper to map Task to the format expected by CustomDayCell
  List<Map<String, dynamic>> _mapTasksToCellEvents(List<Task> tasks) {
    return tasks.map((task) {
      return {
        'title': task.title,
        'priority':
            task.priority.name[0].toUpperCase() +
            task.priority.name.substring(1),
        'color': _getPriorityColor(task.priority),
        'textColor': _getPriorityTextColor(task.priority),
      };
    }).toList();
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return Colors.purple[100]!;
      case TaskPriority.high:
        return Colors.red[100]!;
      case TaskPriority.medium:
        return Colors.blue[100]!;
      case TaskPriority.low:
        return Colors.green[100]!;
    }
  }

  Color _getPriorityTextColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return Colors.purple;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoaded) {
            setState(() {
              _events = _groupTasksByDate(state.tasks);
            });
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TaskBloc>().add(LoadTasksEvent());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Title Month Year
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '${_months[_focusedDay.month - 1]}, ${_focusedDay.year}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Month Selector
                      MonthSelector(
                        months: _months,
                        focusedDay: _focusedDay,
                        onMonthSelected: (newDate) {
                          setState(() {
                            _focusedDay = newDate;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: TableCalendar<Task>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    headerVisible: false,
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    rowHeight: 100,
                    daysOfWeekHeight: 40,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekendStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      weekdayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });

                      // Navigate to details page
                      final tasks = _getEventsForDay(selectedDay);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DayTaskListPage(date: selectedDay, tasks: tasks),
                        ),
                      );
                    },
                    eventLoader: _getEventsForDay,
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final tasks = _getEventsForDay(day);
                        return CustomDayCell(
                          day: day,
                          events: _mapTasksToCellEvents(tasks),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                        final tasks = _getEventsForDay(day);
                        return CustomDayCell(
                          day: day,
                          isToday: true,
                          events: _mapTasksToCellEvents(tasks),
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        final tasks = _getEventsForDay(day);
                        return CustomDayCell(
                          day: day,
                          isSelected: true,
                          events: _mapTasksToCellEvents(tasks),
                        );
                      },
                      outsideBuilder: (context, day, focusedDay) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return const SizedBox();

                        final tasks = events;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: tasks.take(3).map((task) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 1.5,
                              ),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getPriorityColor(task.priority),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
