import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/host/controller/updates_from_employee_controller.dart';

class UpdatesFromEmployeeScreen extends StatefulWidget {
  const UpdatesFromEmployeeScreen({super.key});

  @override
  State<UpdatesFromEmployeeScreen> createState() =>
      _UpdatesFromEmployeeScreenState();
}

class _UpdatesFromEmployeeScreenState extends State<UpdatesFromEmployeeScreen> {
  final AllTasksUpdatesController _controller = Get.put(
    AllTasksUpdatesController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.fetchAllTasksUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Tasks Updates")),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.allTasksUpdatesList.isEmpty) {
          return const Center(child: Text("No updates found"));
        }

        return ListView.builder(
          itemCount: _controller.allTasksUpdatesList.length,
          itemBuilder: (context, dateIndex) {
            final dateData = _controller.allTasksUpdatesList[dateIndex];
            return Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ExpansionTile(
                title: Text(
                  dateData.date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: dateData.users.map((user) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ExpansionTile(
                      title: Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        _buildTaskSection("What You Did", user.whatYouDid),
                        _buildTaskSection(
                          "What You Will Do",
                          user.whatYouWillDo,
                        ),
                        _buildTaskSection("Blockers", user.blockers),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildTaskSection(String title, List tasks) {
    if (tasks.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 4),
          ...tasks.map((task) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.task_alt, size: 18, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project: ${task.project}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          task.taskDescription,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Status: ${task.status}",
                          style: TextStyle(
                            fontSize: 12,
                            color: task.status == 'completed'
                                ? Colors.green
                                : task.status == 'pending'
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
