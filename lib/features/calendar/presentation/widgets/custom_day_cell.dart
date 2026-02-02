import 'package:flutter/material.dart';

class CustomDayCell extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final List<Map<String, dynamic>>
  events; // Nhận danh sách sự kiện từ bên ngoài

  const CustomDayCell({
    super.key,
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.events = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        border: isToday
            ? Border.all(
                color: Colors.blue,
                width: 2,
              ) // Bold blue border for today
            : Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Số ngày
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                color: isToday ? Colors.blue : Colors.black,
              ),
            ),
          ),

          // Hiển thị Event đầu tiên (nếu có)
          if (events.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    events.first['title'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: events.first['color'],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      events.first['priority'],
                      style: TextStyle(
                        fontSize: 10,
                        color: events.first['textColor'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
