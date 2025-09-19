import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/features/auth/controller/logout_request_controller.dart';
import 'package:message_notifier/features/auth/view/login_screen.dart';
import 'package:message_notifier/features/host/controller/host_profile_controller.dart';
import 'package:message_notifier/features/host/controller/update_hostprofile_controller.dart';

class HostProfileScreen extends StatefulWidget {
  const HostProfileScreen({super.key});

  @override
  State<HostProfileScreen> createState() => _HostProfileScreenState();
}

class _HostProfileScreenState extends State<HostProfileScreen> {
  final HostProfileController _hostProfileController = Get.put(
    HostProfileController(),
  );
  final LogoutRequestController _logoutController = Get.put(
    LogoutRequestController(),
  );
  final UpdateHostprofileController hostprofileController = Get.put(
    UpdateHostprofileController(),
  );

  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController dobController;

  bool controllersInitialized = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hostProfileController.getHostProfile();
  }

  void initControllers() {
    if (!controllersInitialized &&
        _hostProfileController.hostProfile.value != null) {
      final data = _hostProfileController.hostProfile.value!;
      emailController = TextEditingController(text: data.email);
      phoneController = TextEditingController(text: data.phone);
      addressController = TextEditingController(text: data.address);
      dobController = TextEditingController(text: data.dob);
      controllersInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_hostProfileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = _hostProfileController.hostProfile.value;
        if (data == null) {
          return const Center(child: Text("No profile data"));
        }

        initControllers();

        return Stack(
          children: [
            // Gradient Header Background
            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E8B7F), Color(0xFF0D4F47)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),

            // Scrollable Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Profile Avatar Card
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            data.profile != null && data.profile!.isNotEmpty
                            ? NetworkImage(data.profile!)
                            : null,
                        child: (data.profile == null || data.profile!.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF2E8B7F),
                              )
                            : null,
                      ),
                    ),

                    Text(
                      data.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.designation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Profile Form Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Profile Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E8B7F),
                              ),
                            ),
                            const SizedBox(height: 20),

                            _buildInputField(
                              controller: emailController,
                              label: "Email Address",
                              hint: "Enter your email",
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Please enter email";
                                if (!GetUtils.isEmail(value))
                                  return "Enter valid email";
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            _buildInputField(
                              controller: phoneController,
                              label: "Phone Number",
                              hint: "Phone number (read-only)",
                              icon: Icons.phone_outlined,
                              isReadOnly: true,
                            ),
                            const SizedBox(height: 20),

                            _buildInputField(
                              controller: addressController,
                              label: "Address",
                              hint: "Enter your address",
                              icon: Icons.location_on_outlined,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 20),

                            _buildDateField(),

                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final updated = getUpdatedFields();
                                  if (updated.isNotEmpty) {
                                    hostprofileController.updateProfile(
                                      updated,
                                    );
                                    Get.snackbar("SuccessFully Updataed", "");
                                  } else {
                                    Get.snackbar("Info", "No changes detected");
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: const Color(0xFF2E8B7F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.save_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Update Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Logout Card
                    Column(
                      children: [
                        const Icon(Icons.logout, color: Colors.red, size: 30),

                        Obx(
                          () => _logoutController.isLoading.value
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () => _showLogoutDialog(context),
                                  style: ElevatedButton.styleFrom(
                                    // backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Input field builder
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isReadOnly = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF2E8B7F)),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // DOB field
  Widget _buildDateField() {
    return _buildInputField(
      controller: dobController,
      label: "Date of Birth",
      hint: "YYYY-MM-DD",
      icon: Icons.calendar_today,
      isReadOnly: true,
    );
  }

  Map<String, dynamic> getUpdatedFields() {
    final data = _hostProfileController.hostProfile.value;
    if (data == null) return {};
    final Map<String, dynamic> updated = {};
    if (emailController.text != data.email)
      updated['email'] = emailController.text;
    if (phoneController.text != data.phone)
      updated['phone'] = phoneController.text;
    if (addressController.text != data.address)
      updated['address'] = addressController.text;
    if (dobController.text != data.dob) updated['dob'] = dobController.text;
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
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
