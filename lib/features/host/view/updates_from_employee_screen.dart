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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // AppBar with your gradient + rounded bottom
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60),
      //   child: AppBar(
      //     elevation: 0,
      //     backgroundColor: Colors.transparent,
      //     centerTitle: false,
      //     titleSpacing: 16,
      //     // keep the title
      //     title: const Text(
      //       "Employees Update",
      //       style: TextStyle(
      //         fontWeight: FontWeight.w400,
      //         letterSpacing: .2,
      //         color: Colors.white,
      //       ),
      //     ),

      //     // <<< custom back button
      //     leadingWidth: 55, // extra room for the container + padding

      //     leading: Padding(
      //       padding: const EdgeInsets.only(left: 10),
      //       child: InkWell(
      //         borderRadius: BorderRadius.circular(12),
      //         onTap: () => Get.back(), // or Navigator.of(context).maybePop()
      //         child: Container(
      //           padding: const EdgeInsets.all(8),
      //           decoration: BoxDecoration(
      //             color: Colors.white.withOpacity(0.15),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: const Icon(
      //             Icons.arrow_back,
      //             color: Colors.white,
      //             size: 22,
      //           ),
      //         ),
      //       ),
      //     ),

      //     // >>>
      //     flexibleSpace: Container(
      //       decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [Color(0xFF00796B), Color(0xFF26A69A)],
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         ),
      //         borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Color(0x33000000),
      //             blurRadius: 12,
      //             offset: Offset(0, 4),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          Container(
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
            child: SafeArea(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: const Text(
                  "Employees Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            if (_controller.isLoading.value) {
              return const Expanded(child: _LoadingState());
            }

            if (_controller.allTasksUpdatesList.isEmpty) {
              return Expanded(
                child: _EmptyState(onRetry: _controller.fetchAllTasksUpdates),
              );
            }

            return Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: () async => _controller.fetchAllTasksUpdates(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  itemCount: _controller.allTasksUpdatesList.length,
                  itemBuilder: (context, dateIndex) {
                    final dateData = _controller.allTasksUpdatesList[dateIndex];

                    return _ElevatedCard(
                      child: Theme(
                        data: theme.copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.tealAccent.withOpacity(.08),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          childrenPadding: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                            bottom: 12,
                          ),
                          leading: _DateBadge(text: dateData.date),
                          title: Text(
                            dateData.date,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          iconColor: Colors.teal.shade600,
                          collapsedIconColor: Colors.teal.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                          collapsedBackgroundColor: Colors.white,
                          children: [
                            const _SectionDivider(),
                            // Users under this date
                            ...dateData.users.map((user) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 6,
                                ),
                                child: _SubCard(
                                  child: ExpansionTile(
                                    tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    childrenPadding: const EdgeInsets.fromLTRB(
                                      6,
                                      4,
                                      6,
                                      10,
                                    ),
                                    leading: _AvatarCircle(name: user.username),
                                    title: Text(
                                      user.username,
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    iconColor: Colors.teal.shade700,
                                    collapsedIconColor: Colors.teal.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.white,
                                    collapsedBackgroundColor: Colors
                                        .grey
                                        .shade50
                                        .withOpacity(.8),
                                    children: [
                                      _buildTaskSection(
                                        "What You Did Yesterday?",
                                        user.whatYouDid,
                                      ),
                                      _buildTaskSection(
                                        "What You Will Do today?",
                                        user.whatYouWillDo,
                                      ),
                                      _buildTaskSection(
                                        "Blockers",
                                        user.blockers,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------- UI helpers (no logic change) ----------

  Widget _buildTaskSection(String title, List tasks) {
    if (tasks.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: title),
          const SizedBox(height: 6),
          ...tasks.map((task) {
            final status = (task.status ?? '').toString().toLowerCase();

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.task_alt,
                      size: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project & status line
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Project: ${task.project}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _StatusChip(status: status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.taskDescription,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey.shade900,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------- Pretty, reusable UI pieces ----------

class _ElevatedCard extends StatelessWidget {
  const _ElevatedCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _SubCard extends StatelessWidget {
  const _SubCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.teal.shade600,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  Color _bg(String s) {
    switch (s) {
      case 'completed':
        return const Color(0xFFE6F4EA);
      case 'pending':
        return const Color(0xFFFFF4E5);
      case 'blocked':
      case 'blockers':
        return const Color(0xFFFDEAEA);
      default:
        return const Color(0xFFEFF3F7);
    }
  }

  Color _fg(String s) {
    switch (s) {
      case 'completed':
        return const Color(0xFF1E8E3E);
      case 'pending':
        return const Color(0xFFB7791F);
      case 'blocked':
      case 'blockers':
        return const Color(0xFFB00020);
      default:
        return const Color(0xFF455A64);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = status.isEmpty ? 'unknown' : status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bg(s),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _fg(s).withOpacity(.25)),
      ),
      child: Text(
        s,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: _fg(s),
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.teal.shade600,
      child: const Icon(
        Icons.calendar_today_rounded,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? "U"
        : name
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join();

    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.teal.shade50,
      foregroundColor: Colors.teal.shade700,
      child: Text(
        initials,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 8,
      thickness: .8,
      color: Colors.grey.shade200,
      indent: 12,
      endIndent: 12,
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text(
              "No updates found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Pull down to refresh or tap the button below.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13.5),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
