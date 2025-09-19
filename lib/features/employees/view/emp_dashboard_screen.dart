import 'package:flutter/material.dart';
import 'package:message_notifier/features/employees/view/standup_history_screen.dart';
import 'package:message_notifier/features/employees/view/meetings_update_screen.dart';
import 'package:message_notifier/features/employees/view/notification_screen.dart';
import 'package:message_notifier/features/employees/view/emp_profile_screen.dart';
import 'package:message_notifier/features/employees/view/submit_daily_task_screen.dart';

class EmpDashboardScreen extends StatefulWidget {
  const EmpDashboardScreen({super.key});

  @override
  State<EmpDashboardScreen> createState() => _EmpDashboardScreenState();
}

class _EmpDashboardScreenState extends State<EmpDashboardScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    MeetingsUpdateScreen(),
    StandupHistoryScreen(),
    NotificationScreen(),
    EmployeeProfileScreen(),
  ];

  final List<String> titles = const [
    "Home",
    "History",
    "Notifications",
    "Profile",
  ];

  /// 🔹 Common gradient used in LoginScreen
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2E8B7F), // Rich teal
      Color(0xFF1F5F5B), // Darker teal
      Color(0xFF0D4F47), // Deep teal
    ],
    stops: [0.0, 0.6, 1.0],
  );

  void onPageTapped(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: mainGradient),
        child: Column(
          children: [
            // _buildHeader(),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: pages[currentIndex],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// 🔹 Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B), Color(0xFF0D4F47)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.history, "History", 1),
              _buildFloatingButton(),
              _buildNavItem(Icons.notifications, "Notifications", 2),
              _buildNavItem(Icons.person, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Bottom Nav Item
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onPageTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white24 : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: isSelected ? 28 : 24, color: Colors.white),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: Colors.white,
              fontSize: isSelected ? 13 : 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  /// 🔹 Floating Action Button in middle
  Widget _buildFloatingButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SubmitDailyTaskScreen(),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: const Icon(Icons.add, color: Color(0xFF2E8B7F), size: 30),
      ),
    );
  }
}
