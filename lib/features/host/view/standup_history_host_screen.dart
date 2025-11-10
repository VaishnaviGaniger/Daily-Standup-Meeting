import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/employees/controller/standup_history_controller.dart';

class StandupHistoryHostScreen extends StatefulWidget {
  const StandupHistoryHostScreen({super.key});

  @override
  State<StandupHistoryHostScreen> createState() =>
      _StandupHistoryHostScreenState();
}

class _StandupHistoryHostScreenState extends State<StandupHistoryHostScreen> {
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
    return List.generate(lastDay.day, (i) => firstDay.add(Duration(days: i)));
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
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
      body: RefreshIndicator(
        onRefresh: () =>
            _standupHistoryController.fetchStandupHistory(date: _selectedDate),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.dark_teal,
              elevation: 0,
              pinned: true, // keeps a thin header pinned
              floating: false,
              snap: false,
              expandedHeight: 160, // calendar height
              collapsedHeight: 0, // fully collapse calendar
              toolbarHeight: 0, // hide default toolbar
              flexibleSpace: FlexibleSpaceBar(background: _buildCalendar()),
            ),
          ],
          body: Obx(() {
            if (_standupHistoryController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final history = _standupHistoryController.history.value;
            if (history == null) return _emptyState();

            return ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _dateHeader(),
                const SizedBox(height: 24),
                _buildTaskSection(
                  "Yesterday's Tasks",
                  history.yesterday,
                  const Color(0xFF5B8DEE),
                  Icons.history,
                ),
                const SizedBox(height: 20),
                _buildTaskSection(
                  "Today's Tasks",
                  history.today,
                  const Color(0xFF4CAF50),
                  Icons.today,
                ),
                const SizedBox(height: 20),
                _buildTaskSection(
                  "Blockers",
                  history.blockers,
                  const Color(0xFFE57373),
                  Icons.block,
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// Collapsible calendar inside the SliverAppBar
  Widget _buildCalendar() {
    final days = _getDaysInMonth(_currentMonth);

    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.dark_teal,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(15),
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
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
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isSelected =
                      day.day == _selectedDate.day &&
                      day.month == _selectedDate.month &&
                      day.year == _selectedDate.year;

                  final now = DateTime.now();
                  final isToday =
                      day.day == now.day &&
                      day.month == now.month &&
                      day.year == now.year;

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
                            DateFormat('EEE').format(day).toUpperCase(),
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
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _dateHeader() => Container(
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
        Icon(Icons.event_note, color: AppColors.dark_teal, size: 24),
        const SizedBox(width: 12),
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.dark_teal,
          ),
        ),
      ],
    ),
  );

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
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.folder, color: color, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            task.project_name ?? 'Unknown Project',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Description + Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.taskDescription ?? '',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _statusPill(task.status ?? '', color),
                      ],
                    ),

                    // Time
                    if ((task.timeTaken != null) &&
                        task.timeTaken.toString().trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _normalizeTimeTaken(task.timeTaken.toString()),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _statusPill(String status, Color baseColor) {
    final display = status.trim().isEmpty ? '—' : status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        display,
        style: TextStyle(
          color: baseColor,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
          letterSpacing: .2,
        ),
      ),
    );
  }

  String _normalizeTimeTaken(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return t;
    final lower = t.toLowerCase();
    final hasHr =
        lower.contains('hr') || lower.contains('hrs') || lower.contains('hour');
    return hasHr ? t : '$t hr';
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          "No standup data for this date",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    ),
  );
}
