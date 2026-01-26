import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Import 2 file widget vừa tạo (nhớ sửa đường dẫn nếu bạn đặt trong thư mục khác)
import '../widgets/custom_day_cell.dart';
import '../widgets/month_selector.dart'; 

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Dữ liệu mẫu
  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime.utc(2026, 1, 2): [
      {'title': 'Bug fixing', 'priority': 'High', 'color': Colors.orange[100], 'textColor': Colors.orange}
    ],
    DateTime.utc(2026, 1, 6): [
      {'title': 'Update', 'priority': 'Low', 'color': Colors.green[100], 'textColor': Colors.green}
    ],
    DateTime.utc(2025, 5, 8): [
      {'title': 'Design t..', 'priority': 'High', 'color': Colors.orange[100], 'textColor': Colors.orange}
    ],
    DateTime.utc(2025, 5, 11): [
      {'title': 'Impleme..', 'priority': 'Medium', 'color': Colors.blue[100], 'textColor': Colors.blue}
    ],
     DateTime.utc(2025, 5, 15): [
      {'title': 'Update', 'priority': 'Low', 'color': Colors.green[100], 'textColor': Colors.green}
    ],
     DateTime.utc(2025, 5, 23): [
      {'title': 'Update', 'priority': 'Low', 'color': Colors.green[100], 'textColor': Colors.green}
    ],
  };

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text('Calendar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          
          // Tiêu đề Tháng Năm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${_months[_focusedDay.month - 1]}, ${_focusedDay.year}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          // --- SỬ DỤNG WIDGET MỚI: MonthSelector ---
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

          Expanded(
            child: TableCalendar(
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
                weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              
              calendarBuilders: CalendarBuilders(
                // --- SỬ DỤNG WIDGET MỚI: CustomDayCell ---
                
                defaultBuilder: (context, day, focusedDay) {
                  return CustomDayCell(
                    day: day, 
                    events: _getEventsForDay(day),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return CustomDayCell(
                    day: day, 
                    isToday: true, 
                    events: _getEventsForDay(day),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return CustomDayCell(
                    day: day, 
                    isSelected: true, 
                    events: _getEventsForDay(day),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                   return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(8),
                    child: Text('${day.day}', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}