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

  Map<String, List<dynamic>> _groupByProject(List tasks) {
    final map = <String, List<dynamic>>{};
    for (var t in tasks) {
      (map[t.project_name ?? 'Unknown Project'] ??= []).add(t);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () =>
            _standupHistoryController.fetchStandupHistory(date: _selectedDate),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.dark_teal,
                elevation: 0,
                pinned: true, // keep a tiny bar pinned as it collapses
                floating: false,
                snap: false,
                expandedHeight: 170,
                collapsedHeight: 0,
                toolbarHeight: 0,
                flexibleSpace: FlexibleSpaceBar(background: _buildCalendar()),
              ),
            ];
          },
          body: Obx(() {
            if (_standupHistoryController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final history = _standupHistoryController.history.value;
            if (history == null) {
              return _empty();
            }

            // Use a ListView (not SingleChildScrollView) inside NestedScrollView
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _dateHeader(),
                const SizedBox(height: 20),
                _buildTaskSection(
                  "Yesterday's Tasks",
                  history.yesterday,
                  const Color(0xFF5B8DEE),
                  Icons.history,
                ),
                const SizedBox(height: 16),
                _buildTaskSection(
                  "Today's Tasks",
                  history.today,
                  const Color(0xFF4CAF50),
                  Icons.today,
                ),
                const SizedBox(height: 16),
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

  /// ── Collapsible calendar content (moved into a builder) ────────────────────
  Widget _buildCalendar() {
    return Container(
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _getDaysInMonth(_currentMonth).length,
              itemBuilder: (_, i) {
                final day = _getDaysInMonth(_currentMonth)[i];
                final isSelected =
                    _selectedDate.day == day.day &&
                    _selectedDate.month == day.month &&
                    _selectedDate.year == day.year;
                final now = DateTime.now();
                final isToday =
                    now.day == day.day &&
                    now.month == day.month &&
                    now.year == day.year;

                return GestureDetector(
                  onTap: () => _selectDate(day),
                  child: Container(
                    width: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(.15),
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
                                : Colors.white.withOpacity(.7),
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
    );
  }

  /// ── Empty state ────────────────────────────────────────────────────────────
  Widget _empty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 12),
        Text("No standup data", style: TextStyle(color: Colors.grey[600])),
      ],
    ),
  );

  /// ── Date header (sticky below the calendar) ───────────────────────────────
  Widget _dateHeader() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.dark_teal.withOpacity(.1),
          AppColors.dark_teal.withOpacity(.05),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.event_note, color: AppColors.dark_teal),
        const SizedBox(width: 12),
        Text(
          DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
          style: TextStyle(
            color: AppColors.dark_teal,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );

  /// ── Task section ──────────────────────────────────────────────────────────
  Widget _buildTaskSection(String title, List tasks, Color c, IconData i) {
    final grouped = _groupByProject(tasks);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.withOpacity(.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(i, color: c),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: c.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${tasks.length}',
                style: TextStyle(color: c, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...grouped.entries.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 6),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group header
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: c.withOpacity(.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.folder, color: c),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: c.withOpacity(.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${e.value.length}',
                          style: TextStyle(
                            color: c,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Task rows
                  ...e.value.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _taskCard(
                        desc: t.taskDescription ?? "",
                        status: t.status ?? "",
                        time: t.timeTaken ?? "",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// ── Task card ─────────────────────────────────────────────────────────────
  Widget _taskCard({
    required String desc,
    required String status,
    required String time,
  }) {
    final sc = _statusColor(status);
    final hasTime = time.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // description + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: sc.withOpacity(.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status.isEmpty ? '—' : status,
                  style: TextStyle(
                    color: sc,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    letterSpacing: .2,
                  ),
                ),
              ),
            ],
          ),

          // time row (optional)
          if (hasTime) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14),
                const SizedBox(width: 6),
                Text(
                  _normalizeTimeTaken(time),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String s) {
    s = s.toLowerCase();
    if (s.contains("done") || s.contains("complete")) return Colors.green;
    if (s.contains("block")) return Colors.red;
    if (s.contains("progress")) return Colors.orange;
    return Colors.blue;
  }

  // Helper: add "hr" if not present (UI formatting only)
  String _normalizeTimeTaken(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return t;
    final lower = t.toLowerCase();
    final hasHr =
        lower.contains('hr') || lower.contains('hrs') || lower.contains('hour');
    return hasHr ? t : '$t hr';
  }
}
