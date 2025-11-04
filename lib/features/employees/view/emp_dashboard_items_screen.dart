import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/employees/controller/emp_profile_controller.dart';
import 'package:message_notifier/features/employees/controller/meeting_update_controller.dart';
import 'package:message_notifier/features/employees/controller/standup_history_controller.dart';
import 'package:message_notifier/features/employees/view/List_of_teammates_screen.dart';
import 'package:message_notifier/features/employees/view/assign_tasks_screen.dart';
import 'package:message_notifier/features/employees/view/emp_profile_screen.dart';
import 'package:message_notifier/features/employees/view/notification_screen.dart';
import 'package:message_notifier/features/employees/view/pending_tasks_employee_screen.dart';
import 'package:message_notifier/features/employees/view/todays_plans_screen_employee.dart';

class EmpDashboardItemsScreen extends StatefulWidget {
  const EmpDashboardItemsScreen({super.key});

  @override
  State<EmpDashboardItemsScreen> createState() =>
      _EmpDashboardItemsScreenState();
}

class _EmpDashboardItemsScreenState extends State<EmpDashboardItemsScreen> {
  final MeetingUpdateController _meetingUpdateController = Get.put(
    MeetingUpdateController(),
  );
  final EmpProfileController _empProfileController = Get.put(
    EmpProfileController(),
  );
  final StandupHistoryController _standupHistoryController = Get.put(
    StandupHistoryController(),
  );

  @override
  void initState() {
    super.initState();
    _empProfileController.fetchprofile();
    _standupHistoryController.fetchStandupHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // host background
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildBody(),
    );
  }

  // ---------- APP BAR (host style) ----------
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00796B), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          toolbarHeight: 70,
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
          title: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome back,",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(230, 255, 255, 255),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _empProfileController.profile.value?.username ?? "User",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- FLOATING ACTION BUTTON (host style) ----------
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF00796B),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        "Create",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        // Keep employee flow: open Assign Tasks or Submit Daily Tasks as you prefer.
        // Here we navigate to AssignTasksScreen to match employee actions.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AssignTasksScreen()),
        );
      },
    );
  }

  // ---------- DRAWER (host look, employee items) ----------
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildDrawerTile(
                    icon: Icons.person_rounded,
                    title: "Profile",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EmployeeProfileScreen(),
                      ),
                    ),
                  ),

                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 56,
                    endIndent: 16,
                    color: Color(0xFFE2E8F0),
                  ),
                  _buildDrawerTile(
                    icon: Icons.task_alt_outlined,
                    title: "Assign Tasks",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AssignTasksScreen(),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 56,
                    endIndent: 16,
                    color: Color(0xFFE2E8F0),
                  ),
                  _buildDrawerTile(
                    icon: Icons.group_add_rounded,
                    title: "Add Teammates",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListOfTeammatesScreen(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset("assets/images/logo.png", height: 40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00796B), Color(0xFF26A69A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              _empProfileController.profile.value?.username
                      ?.substring(0, 1)
                      .toUpperCase() ??
                  'E',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00796B),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _empProfileController.profile.value?.username ?? "Employee",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _empProfileController.profile.value?.designation ??
                      "Software Engineer",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: const Color(0xFF00796B).withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00796B).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF00796B), size: 22),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              horizontalTitleGap: 12,
            ),
          ),
        ),
      ),
    );
  }

  // ---------- BODY ----------
  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () => _standupHistoryController.fetchStandupHistory(),
      color: const Color(0xFF00796B),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActions(),
            const SizedBox(height: 20),
            _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  // ---------- QUICK ACTIONS (employee actions kept) ----------
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00796B), Color(0xFF26A69A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              _buildCompactActionCard(
                icon: Icons.assignment_turned_in_rounded,
                label: "Submit Daily Tasks",
                gradient: const [Color(0xFF00796B), Color(0xFF26A69A)],
                onTap: () {},
              ),
              const SizedBox(width: 2),
              _buildCompactActionCard(
                icon: Icons.rocket_launch_rounded,
                label: "Today's Plans",
                gradient: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                onTap: () => Get.to(() => const TodaysPlansScreenEmployee()),
              ),
              const SizedBox(width: 2),
              _buildCompactActionCard(
                icon: Icons.pending_actions_rounded,
                label: "Pending Tasks",
                gradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                onTap: () => Get.to(() => PendingTasksEmployeeScreen()),
              ),
              //const SizedBox(width: 12),
              // _buildModernActionCard(
              //   icon: Icons.groups_rounded,
              //   label: "Team Overview",
              //   gradient: const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => const ListOfTeammatesScreen(),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActionCard({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: gradient[0].withOpacity(0.1),
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: gradient[0].withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.2,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- SUMMARY SECTION ----------
  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Today's Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildSummaryCards(),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildElegantSummaryCard(
                  title: "Today's Plans",
                  value:
                      _standupHistoryController.history.value?.today.length
                          .toString() ??
                      '0',
                  subtitle: "tasks ",
                  icon: Icons.event_note_rounded,
                  gradient: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                  accentColor: const Color(0xFF1E40AF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildElegantSummaryCard(
                  title: "Yesterday's Tasks",
                  value:
                      _standupHistoryController.history.value?.yesterday.length
                          .toString() ??
                      '0',
                  subtitle: "tasks",
                  icon: Icons.check_circle_rounded,
                  gradient: const [Color(0xFF10B981), Color(0xFF34D399)],
                  accentColor: const Color(0xFF047857),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildWideElegantSummaryCard(
            title: "Active Blockers",
            value:
                _standupHistoryController.history.value?.blockers.length
                    .toString() ??
                '0',
            subtitle: "issues requiring immediate attention",
            icon: Icons.warning_amber_rounded,
            gradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
            accentColor: const Color(0xFFD97706),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required Color accentColor,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gradient[0].withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    gradient[1].withOpacity(0.08),
                    gradient[1].withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        height: 1,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideElegantSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required Color accentColor,
  }) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gradient[0].withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    gradient[1].withOpacity(0.08),
                    gradient[1].withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                              height: 1,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(List<Color> gradient) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: gradient[0].withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
