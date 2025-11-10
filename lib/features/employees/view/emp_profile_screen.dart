import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
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
  final LogoutRequestController _logoutController = Get.put(
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
    if (emailController.text != data.email) {
      updated['email'] = emailController.text;
    }
    if (phoneController.text != data.phone) {
      updated['phone'] = phoneController.text;
    }
    if (addressController.text != data.address) {
      updated['address'] = addressController.text;
    }
    if (dobController.text != data.dob) {
      updated['dob'] = dobController.text;
    }
    return updated;
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logoutController.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              "Logout",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_empProfileController.isLoading.value) {
          return _buildGradientBackground(
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
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
                  color: AppColors.white,
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
                      const Expanded(
                        child: Text(
                          "My Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
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
                      color: AppColors.white,
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
                              ).withValues(alpha: 0.1),
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
                                      color: AppColors.rich_teal,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.rich_teal,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.rich_teal.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: AppColors.white,
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
                            color: AppColors.rich_teal,
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
                            color: AppColors.rich_teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.designation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.rich_teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Fields
                        _buildTextField(
                          label: 'Email Address',
                          controller: emailController,
                          icon: Icons.email_outlined,
                          iconButton: null,
                          onPressed: null,
                          readOnly: true,
                        ),
                        const SizedBox(height: 18),
                        _buildTextField(
                          label: 'Mobile Number',
                          controller: phoneController,
                          icon: Icons.phone_outlined,
                          iconButton: null,
                          onPressed: null,
                          readOnly: true,
                        ),
                        const SizedBox(height: 18),
                        _buildTextField(
                          label: 'Address',
                          controller: addressController,
                          icon: Icons.location_on_outlined,
                          iconButton: Icons.edit,
                          onPressed: () {
                            final update = updateAddress();
                            _updateEmployeeProfileController.updateProfile(
                              update,
                            );
                            Get.snackbar(
                              "✅ Updated Successfully",
                              "Address updated: ",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: AppColors.white,
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        _buildTextField(
                          label: 'Date of Registerion',
                          controller: dobController,
                          icon: Icons.calendar_today_outlined,
                          iconButton: Icons.edit,
                          onPressed: () {
                            final update = updateDob();
                            if (update.isNotEmpty) {
                              _updateEmployeeProfileController.updateProfile(
                                update,
                              );
                              Get.snackbar(
                                "Updated Successfully",
                                "",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                margin: EdgeInsets.all(12),
                                borderRadius: 10,
                                duration: Duration(seconds: 2),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        // Logout Button
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 54,
                            // decoration: BoxDecoration(
                            //   color: Colors.grey[50],
                            //   borderRadius: BorderRadius.circular(16),
                            //   border: Border.all(color: Colors.grey[200]!),
                            // ),
                            child: _logoutController.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.red[400],
                                      strokeWidth: 2,
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () {
                                      _showLogoutDialog(context);
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
          colors: [AppColors.rich_teal, Color(0xFF1F5F5B), Color(0xFF0D4F47)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required IconData? iconButton,
    required VoidCallback? onPressed,
    bool readOnly = false,
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
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
              suffixIcon: iconButton != null
                  ? IconButton(onPressed: onPressed, icon: Icon(iconButton))
                  : null,
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
          colors: [AppColors.rich_teal, Color(0xFF1F5F5B)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.rich_teal.withOpacity(0.25),
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
        icon: Icon(icon, color: AppColors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> updateAddress() {
    final data = _empProfileController.profile.value;
    if (data == null) return {};

    Map<String, dynamic> updatedAddress = {};
    if (addressController.text != data.address) {
      updatedAddress['address'] = addressController.text;
    }
    return updatedAddress;
  }

  Map<String, dynamic> updateDob() {
    final data = _empProfileController.profile.value;
    if (data == null) return {};

    Map<String, dynamic> updatedDob = {};
    if (dobController.text != data.dob) {
      updatedDob['dob'] = dobController.text;
    }
    return updatedDob;
  }
}
