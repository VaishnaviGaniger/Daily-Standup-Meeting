import 'package:flutter/material.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/host/view/host_dashboard_items_Screen.dart';
import 'package:message_notifier/features/host/view/standup_history_host_screen.dart';
import 'package:message_notifier/features/host/view/submit_daily_tasks_screen.dart';

class HostDashboardScreen extends StatefulWidget {
  const HostDashboardScreen({super.key});

  @override
  State<HostDashboardScreen> createState() => _HostDashboardScreenState();
}

class _HostDashboardScreenState extends State<HostDashboardScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HostDashboardHomeScreen(),

    // MeetingUpdateScreen(),
    StandupHistoryHostScreen(),
    // HostNotificationScreen(),
    // HostProfileScreen(),
  ];

  void onPageTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 1
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              title: Text("Standup History"),
              centerTitle: true,
              foregroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: AppColors.dark_teal,
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.rich_teal,
              AppColors.dark_teal,
              AppColors.darkest_teal,
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(child: pages[currentIndex]),
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.rich_teal, AppColors.darkest_teal],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E8B7F).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        // wraped with safearea --change
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildFloatingActionButton(),
            _buildNavItem(Icons.history, "History", 1),

            // _buildNavItem(Icons.notifications, "Notifications", 2),
            // _buildNavItem(Icons.person, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onPageTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
            child: Icon(
              icon,
              color: AppColors.white,
              size: isSelected ? 28 : 24,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: AppColors.white,
              fontSize: isSelected ? 13 : 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SubmitDailyTaskHostScreen(),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Color(0xFF2E8B7F), size: 30),
      ),
    );
  }
}
