import 'package:flutter/material.dart';
import 'package:message_notifier/features/host/view/host_notification_screen.dart';
import 'package:message_notifier/features/host/view/host_profile_screen.dart';
import 'package:message_notifier/features/host/view/meeting_update_screen.dart';
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
    MeetingUpdateScreen(),
    StandupHistoryHostScreen(),
    HostNotificationScreen(),
    HostProfileScreen(),
  ];

  void onPageTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E8B7F), // Teal 1 (same as login screen)
              Color(0xFF1F5F5B), // Teal 2
              Color(0xFF0D4F47), // Dark teal
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
          colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E8B7F).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.history, "History", 1),
              _buildFloatingActionButton(),
              _buildNavItem(Icons.notifications, "Notifications", 2),
              _buildNavItem(Icons.person, "Profile", 3),
            ],
          ),
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
            child: Icon(icon, color: Colors.white, size: isSelected ? 28 : 24),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: Colors.white,
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
            builder: (context) => const SubmitDailyTaskScreens(),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
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
