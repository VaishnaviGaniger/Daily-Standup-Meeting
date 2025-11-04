import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/employees/controller/standup_history_controller.dart';
import 'package:intl/intl.dart';

class StandupHistoryScreen extends StatefulWidget {
  const StandupHistoryScreen({super.key});

  @override
  State<StandupHistoryScreen> createState() => _StandupHistoryScreenState();
}

class _StandupHistoryScreenState extends State<StandupHistoryScreen> {
  final _standupHistoryController = Get.put(StandupHistoryController());
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _standupHistoryController.fetchStandupHistory();
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    List<DateTime> days = [];
    for (int i = 0; i < lastDay.day; i++) {
      days.add(firstDay.add(Duration(days: i)));
    }
    return days;
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    // final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    _standupHistoryController.fetchStandupHistory(date: date);
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   leading:
      //   backgroundColor: AppColors.dark_teal,
      // ),
      body: RefreshIndicator(
        onRefresh: () =>
            _standupHistoryController.fetchStandupHistory(date: _selectedDate),
        child: Column(
          children: [
            // Calendar Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.dark_teal,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_teal.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 30, 16, 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(
                        //   onPressed: () => Navigator.pop(context),
                        //   icon: const Icon(
                        //     Icons.arrow_back,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          onPressed: () => _changeMonth(-1),
                        ),
                        Text(
                          DateFormat('MMMM, yyyy').format(_currentMonth),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),
                  ),

                  // Weekday labels
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  // child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children:
                  //       ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                  //           .map(
                  //             (day) => SizedBox(
                  //               width: 44,
                  //               child: Center(
                  //                 child: Text(
                  //                   day,
                  //                   style: TextStyle(
                  //                     color: Colors.white.withOpacity(0.7),
                  //                     fontSize: 11,
                  //                     fontWeight: FontWeight.w500,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //           .toList(),
                  // ),
                  // ),

                  // Calendar days - horizontal scrollable
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      itemCount: _getDaysInMonth(_currentMonth).length,
                      itemBuilder: (context, index) {
                        final day = _getDaysInMonth(_currentMonth)[index];
                        final isSelected =
                            day.day == _selectedDate.day &&
                            day.month == _selectedDate.month &&
                            day.year == _selectedDate.year;
                        final isToday =
                            day.day == DateTime.now().day &&
                            day.month == DateTime.now().month &&
                            day.year == DateTime.now().year;

                        return GestureDetector(
                          onTap: () => _selectDate(day),
                          child: Container(
                            width: 56,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: isToday && !isSelected
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('EEE')
                                      .format(day)
                                      .toUpperCase(), // Shows MON, TUE, WED
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.dark_teal
                                        : Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.dark_teal
                                        : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: Obx(() {
                if (_standupHistoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final history = _standupHistoryController.history.value;

                if (history == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No standup data for this date",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.dark_teal.withOpacity(0.1),
                              AppColors.dark_teal.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_note,
                              color: AppColors.dark_teal,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat(
                                'EEEE, MMMM d, yyyy',
                              ).format(_selectedDate),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.dark_teal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Yesterday's Tasks
                      _buildTaskSection(
                        "Yesterday's Tasks",
                        history.yesterday,
                        const Color(0xFF5B8DEE),
                        Icons.history,
                      ),

                      const SizedBox(height: 20),

                      // Today's Tasks
                      _buildTaskSection(
                        "Today's Tasks",
                        history.today,
                        const Color(0xFF4CAF50),
                        Icons.today,
                      ),

                      const SizedBox(height: 20),

                      // Blockers
                      _buildTaskSection(
                        "Blockers",
                        history.blockers,
                        const Color(0xFFE57373),
                        Icons.block,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection(
    String title,
    List tasks,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${tasks.length}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (tasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.inbox_outlined, size: 40, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  "No tasks available",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          )
        else
          ...tasks.map(
            (task) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.task_alt, color: color, size: 24),
                ),
                title: Text(
                  task.taskDescription,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoChip(
                        Icons.info_outline,
                        "Status: ${task.status}",
                        color,
                      ),
                      if (task.timeTaken != null) ...[
                        const SizedBox(height: 6),
                        _buildInfoChip(
                          Icons.access_time,
                          "Time: ${task.timeTaken}",
                          Colors.orange,
                        ),
                      ],
                      const SizedBox(height: 6),
                      _buildInfoChip(
                        Icons.folder_outlined,
                        task.project_name,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color.withOpacity(0.7)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
