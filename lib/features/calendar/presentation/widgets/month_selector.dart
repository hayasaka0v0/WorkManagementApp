import 'package:flutter/material.dart';

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final DateTime focusedDay;
  final Function(DateTime) onMonthSelected;

  const MonthSelector({
    super.key,
    required this.months,
    required this.focusedDay,
    required this.onMonthSelected,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Wrap in post frame callback to ensure list is built before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  @override
  void didUpdateWidget(MonthSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusedDay.month != oldWidget.focusedDay.month) {
      _scrollToCurrentMonth();
    }
  }

  void _scrollToCurrentMonth() {
    if (!_scrollController.hasClients) return;

    // Estimate item width + padding (approx 60-80px depending on text length)
    // A safer approach for exact scrolling requires keeping track of keys or item sizes,
    // but a rough estimate often works well enough for simple lists.
    // Let's assume average item width including padding is around 70.0
    final index = widget.focusedDay.month - 1;
    final double offset = index * 70.0;

    // Center the selected item
    // Screen width / 2
    final screenWidth = MediaQuery.of(context).size.width;
    final centerOffset = screenWidth / 2 - 35; // 35 is half item width

    double finalOffset = offset - centerOffset;

    // Clamp offset
    if (finalOffset < 0) finalOffset = 0;
    if (finalOffset > _scrollController.position.maxScrollExtent) {
      finalOffset = _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      finalOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45, // Increased height slightly
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.months.length,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ), // Add horizontal padding to list
        itemBuilder: (context, index) {
          final isSelected = (index + 1) == widget.focusedDay.month;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6.0,
            ), // Reduced spacing slightly
            child: ActionChip(
              label: Text(widget.months[index]),
              backgroundColor: isSelected ? Colors.blue[100] : Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue[800] : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // More rounded
              ),
              onPressed: () {
                final newDate = DateTime(widget.focusedDay.year, index + 1, 1);
                widget.onMonthSelected(newDate);
              },
            ),
          );
        },
      ),
    );
  }
}
