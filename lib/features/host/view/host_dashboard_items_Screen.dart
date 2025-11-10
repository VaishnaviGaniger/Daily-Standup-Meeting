import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/employees/controller/standup_history_controller.dart';
import 'package:message_notifier/features/host/controller/host_profile_controller.dart';
import 'package:message_notifier/features/host/controller/notification_controller_host.dart';
import 'package:message_notifier/features/host/view/approval_pending_screen.dart';
import 'package:message_notifier/features/host/view/create_project_screen.dart';
import 'package:message_notifier/features/host/view/host_blockers_screen.dart';
import 'package:message_notifier/features/host/view/host_notification_screen.dart';
import 'package:message_notifier/features/host/view/host_profile_screen.dart';
import 'package:message_notifier/features/host/view/pending_tasks_host_screen.dart';
import 'package:message_notifier/features/host/view/schedule_meeting_screen.dart';
import 'package:message_notifier/features/host/view/todays_updates_host_screen.dart';
import 'package:message_notifier/features/host/view/updates_from_employee_screen.dart';

class HostDashboardHomeScreen extends StatefulWidget {
  const HostDashboardHomeScreen({super.key});

  @override
  State<HostDashboardHomeScreen> createState() =>
      _HostDashboardHomeScreenState();
}

class _HostDashboardHomeScreenState extends State<HostDashboardHomeScreen> {
  final HostProfileController _hostProfileController = Get.put(
    HostProfileController(),
  );
  final StandupHistoryController _standupHistoryController = Get.put(
    StandupHistoryController(),
  );
  final NotificationController _notificationController = Get.put(
    NotificationController(),
  );

  @override
  void initState() {
    super.initState();
    _hostProfileController.getHostProfile();
    _standupHistoryController.fetchStandupHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: _buildAppBar(),
        drawer: _buildDrawer(context),
        floatingActionButton: _buildFloatingActionButton(context),
        body: _buildBody(),
      ),
    );
  }

  // ---------------- APP BAR ---------------- //
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back,",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _hostProfileController.hostProfile.value?.username ?? "",
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildNotificationIcon(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- NOTIFICATION ICON ---------------- //
  Widget _buildNotificationIcon() {
    return Obx(
      () => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                _notificationController.clearNotifications();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HostNotificationScreen()),
                );
              },
            ),
          ),
          if (_notificationController.unreadCount.value > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  _notificationController.unreadCount.value > 9
                      ? '9+'
                      : '${_notificationController.unreadCount.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- DRAWER ---------------- //
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
            // ---- Header ---- //
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
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
                    radius: 34,
                    backgroundColor: Colors.white,
                    child: Text(
                      _hostProfileController.hostProfile.value?.username
                              .substring(0, 1)
                              .toUpperCase() ??
                          'H',
                      style: const TextStyle(
                        fontSize: 26,
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
                          _hostProfileController.hostProfile.value?.username ??
                              "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _hostProfileController
                                  .hostProfile
                                  .value
                                  ?.designation ??
                              "Host User",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---- Drawer Items ---- //
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                children: [
                  _buildDrawerTile(
                    icon: Icons.person_rounded,
                    title: "Profile",
                    onTap: () => Get.to(() => const HostProfileScreen()),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 56,
                    endIndent: 16,
                    color: Color(0xFFE2E8F0),
                  ),
                  _buildDrawerTile(
                    icon: Icons.pending_actions_rounded,
                    title: "Approval Pending",
                    onTap: () => Get.to(() => const ApprovalPendingScreen()),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.5,
                    indent: 56,
                    endIndent: 16,
                    color: Color(0xFFE2E8F0),
                  ),
                  // _buildDrawerTile(
                  //   icon: Icons.update_rounded,
                  //   title: "Employee Updates",
                  //   onTap: () =>
                  //       Get.to(() => const UpdatesFromEmployeeScreen()),
                  // ),
                  // const Divider(
                  //   height: 0,
                  //   thickness: 0.5,
                  //   indent: 56,
                  //   endIndent: 16,
                  //   color: Color(0xFFE2E8F0),
                  // ),
                  _buildDrawerTile(
                    icon: Icons.add_circle_rounded,
                    title: "Add New Project",
                    onTap: () => Get.to(() => const CreateProjectScreen()),
                  ),

                  const SizedBox(height: 30),
                  const Divider(
                    thickness: 0.6,
                    indent: 12,
                    endIndent: 12,
                    color: Color(0xFFE2E8F0),
                  ),

                  // ---- Bottom Branding ---- //
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Opacity(
                          opacity: 0.6,
                          child: Image.asset(
                            "assets/images/logo.png",
                            height: 40,
                          ),
                        ),
                      ],
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

  // ---------------- DRAWER TILE ---------------- //
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

  // ---------------- BODY ---------------- //
  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () => _standupHistoryController.fetchStandupHistory(),
      color: const Color(0xFF00796B),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActions(),
            const SizedBox(height: 32),
            _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  // ---------------- QUICK ACTIONS ---------------- //
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

        // --- Horizontal Scroll List --- //
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildCompactActionCard(
                icon: Icons.groups_rounded,
                label: "Team Overview",
                gradient: const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                onTap: () => Get.to(() => const UpdatesFromEmployeeScreen()),
              ),
              _buildCompactActionCard(
                icon: Icons.rocket_launch_rounded,
                label: "Today's Plans",
                gradient: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                onTap: () => Get.to(() => const TodaysUpdatesHostScreen()),
              ),
              _buildCompactActionCard(
                icon: Icons.pending_actions_rounded,
                label: "Pending Tasks",
                gradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                onTap: () => Get.to(() => const PendingTasksHostScreen()),
              ),

              _buildCompactActionCard(
                icon: Icons.assignment_turned_in_rounded,
                label: "Blockers",
                gradient: const [Color(0xFF00796B), Color(0xFF26A69A)],
                onTap: () => Get.to(() => const HostBlockersScreen()),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- SMALL ELEGANT QUICK ACTION CARD ---------------- //
  Widget _buildCompactActionCard({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
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

  // ---------------- SUMMARY SECTION ---------------- //
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
        mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(width: 14),
              Expanded(
                child: _buildElegantSummaryCard(
                  title: "Yesterday",
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
          const SizedBox(height: 14),
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

  // ---------------- FLOATING BUTTON ---------------- //
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF00796B),
      elevation: 8,
      icon: const Icon(Icons.video_call, color: Colors.white),
      label: const Text(
        "Create Meeting",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ScheduleMeetingScreen()),
      ),
    );
  }
}
