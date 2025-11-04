import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message_notifier/config/app_colors.dart';
import 'package:message_notifier/features/host/controller/create_project_controller.dart';
import 'package:message_notifier/features/host/model/create_project_model.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final CreateProjectController controller = Get.put(CreateProjectController());
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController projectnameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Project",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.rich_teal, // Rich teal
              Color(0xFF1F5F5B), // Darker teal
              Color(0xFF0D4F47), // Deepest teal
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 25,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.rich_teal.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.folder_open,
                                color: AppColors.rich_teal,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Project Information',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.rich_teal,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        _buildInputField(
                          controller: projectnameController,
                          label: 'Project Name',
                          hint: 'Enter a project name',
                          icon: Icons.work_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a project name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10),
                        _buildDescriptionField(),

                        SizedBox(height: 32),

                        Row(
                          children: [
                            // Expanded(
                            //   child: Container(
                            //     height: 52,
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //         color: AppColors.rich_teal,
                            //         width: 1.5,
                            //       ),
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     child: TextButton(
                            //       onPressed: () => Navigator.pop(context),
                            //       style: TextButton.styleFrom(
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(12),
                            //         ),
                            //       ),
                            //       child: Text(
                            //         'Cancel',
                            //         style: TextStyle(
                            //           color: AppColors.rich_teal,
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.rich_teal,
                                      Color(0xFF1F5F5B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(
                                        0xFF2E8B7F,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final input = CreateProjectModel(
                                        name: projectnameController.text,
                                        description: descriptionController.text,
                                      );
                                      controller.createproject(input);
                                      Get.back();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.white,
                                    size: 18,
                                  ),
                                  label: Text(
                                    "Create Project",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.white.withValues(alpha: 0.8),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tip: Be specific about your goals to track progress better',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 13,
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
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
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
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Description',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
            decoration: InputDecoration(
              hintText:
                  "Describe your project vision, goals, and key features...",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              prefixIcon: Padding(
                padding: EdgeInsets.only(top: 12, left: 12, right: 8),
                child: Icon(
                  Icons.description_outlined,
                  color: Colors.grey[500],
                  size: 20,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40,
                minHeight: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: 8,
                right: 16,
                top: 16,
                bottom: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please describe your project';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
