import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final List<String> months;
  final DateTime focusedDay;
  final Function(DateTime) onMonthSelected; // Callback gửi ngày về trang chính

  const MonthSelector({
    super.key,
    required this.months,
    required this.focusedDay,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          final isSelected = (index + 1) == focusedDay.month;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ActionChip(
              label: Text(months[index]),
              backgroundColor: isSelected ? Colors.blue[100] : Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue[800] : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.shade300
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              onPressed: () {
                // Tạo ngày mới dựa trên tháng được chọn
                final newDate = DateTime(focusedDay.year, index + 1, 1);
                // Gọi callback để trang cha xử lý setState
                onMonthSelected(newDate);
              },
            ),
          );
        },
      ),
    );
  }
}