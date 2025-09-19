import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/auth/controller/logout_request_controller.dart';
import 'package:message_notifier/features/auth/view/login_screen.dart';
import 'package:message_notifier/features/employees/controller/emp_profile_controller.dart';
import 'package:message_notifier/features/employees/controller/update_employee_profile_controller.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final EmpProfileController _empProfileController = Get.put(
    EmpProfileController(),
  );
  final LogoutRequestController _logoutcontroller = Get.put(
    LogoutRequestController(),
  );
  final UpdateEmployeeProfileController _updateEmployeeProfileController =
      Get.put(UpdateEmployeeProfileController());

  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController dobController;

  bool controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _empProfileController.fetchprofile();
  }

  void initControllers() {
    if (!controllersInitialized &&
        _empProfileController.profile.value != null) {
      final data = _empProfileController.profile.value!;
      emailController = TextEditingController(text: data.email);
      phoneController = TextEditingController(text: data.phone);
      addressController = TextEditingController(text: data.address);
      dobController = TextEditingController(text: data.dob);
      controllersInitialized = true;
    }
  }

  Map<String, dynamic> getUpdatedFields() {
    final data = _empProfileController.profile.value;
    if (data == null) return {};

    Map<String, dynamic> updated = {};
    if (emailController.text != data.email)
      updated['email'] = emailController.text;
    if (phoneController.text != data.phone)
      updated['phone'] = phoneController.text;
    if (addressController.text != data.address)
      updated['address'] = addressController.text;
    if (dobController.text != data.dob) updated['dob'] = dobController.text;
    return updated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_empProfileController.isLoading.value) {
          return _buildGradientBackground(
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          );
        }

        final data = _empProfileController.profile.value;
        if (data == null) {
          return _buildGradientBackground(
            child: const Center(
              child: Text(
                "No profile data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        initControllers();

        return _buildGradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      // IconButton(
                      //   onPressed: () => Navigator.pop(context),
                      //   icon: const Icon(
                      //     Icons.arrow_back_ios,
                      //     color: Colors.white,
                      //     size: 20,
                      //   ),
                      // ),
                      Expanded(
                        child: Text(
                          "     My Profile",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: const Color(
                                0xFF2E8B7F,
                              ).withOpacity(0.1),
                              backgroundImage:
                                  (data.profile != null &&
                                      data.profile!.isNotEmpty)
                                  ? NetworkImage(data.profile!)
                                  : null,
                              child:
                                  (data.profile == null ||
                                      data.profile!.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Color(0xFF2E8B7F),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E8B7F),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2E8B7F,
                                      ).withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Name
                        Text(
                          data.username,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E8B7F),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Designation
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E8B7F).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.designation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2E8B7F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Fields
                        _buildTextField(
                          "Email Address",
                          emailController,
                          Icons.email_outlined,
                        ),
                        const SizedBox(height: 18),
                        _buildTextField(
                          "Phone Number",
                          phoneController,
                          Icons.phone_outlined,
                          readOnly: true,
                          enabled: true,
                        ),
                        const SizedBox(height: 18),
                        _buildTextField(
                          "Address",
                          addressController,
                          Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 18),
                        _buildTextField(
                          "Date of Birth",
                          dobController,
                          Icons.calendar_today_outlined,
                          readOnly: true,
                          enabled: true,
                        ),

                        const SizedBox(height: 28),

                        // Update Button
                        _buildGradientButton(
                          icon: Icons.save_outlined,
                          label: "Update Profile",
                          onPressed: () {
                            final updated = getUpdatedFields();
                            if (updated.isNotEmpty) {
                              _updateEmployeeProfileController.updateProfile(
                                updated,
                              );
                              Get.snackbar("Updated Successfully", "");
                            } else {
                              Get.snackbar("Info", "No changes detected");
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Logout Button
                        Obx(
                          () => Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: _logoutcontroller.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.red[400],
                                      strokeWidth: 2,
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () {
                                      _logoutcontroller.logout();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.logout_rounded,
                                      color: Colors.red[400],
                                    ),
                                    label: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red[400],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGradientBackground({required Widget child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B), Color(0xFF0D4F47)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool readOnly = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            enabled: enabled,

            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E8B7F), Color(0xFF1F5F5B)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E8B7F).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
