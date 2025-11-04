import 'package:flutter/material.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/employees/view/add_teammates_screen.dart';

class ListOfTeammatesScreen extends StatefulWidget {
  const ListOfTeammatesScreen({super.key});

  @override
  State<ListOfTeammatesScreen> createState() => _ListOfTeammatesScreenState();
}

class _ListOfTeammatesScreenState extends State<ListOfTeammatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Team Members",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.rich_teal,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.rich_teal,
              AppColors.dark_teal,
              AppColors.darkest_teal,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: 5, // replace with dynamic data later
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.rich_teal.withOpacity(0.85),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    title: const Text(
                      "Employee Name",
                      style: TextStyle(
                        color: AppColors.rich_teal,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Employee Role",
                      style: TextStyle(
                        color: AppColors.rich_teal.withOpacity(0.8),
                      ),
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () {
                        // Add delete logic here
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text("Remove"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.rich_teal,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        side: const BorderSide(color: AppColors.rich_teal),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.dark_teal,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Teammate",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTeammatesScreen()),
          );
        },
      ),
    );
  }
}
