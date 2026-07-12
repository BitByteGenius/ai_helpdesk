import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/uploads/widget/upload_card.dart';
import 'package:frontend/screens/uploads/widget/upload_progress.dart';
import 'package:get/get.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  // Use the controller's own TextEditingControllers so that
  // ticketController.createTicket() can read the values the user typed.
  late final TicketController ticketController;
  late final AiController ai;
  late final UploadController upload;

  @override
  void initState() {
    super.initState();
    ticketController = Get.find<TicketController>();
    ai = Get.find<AiController>();
    upload = Get.find<UploadController>();

    // Sync AI analysis results into the controller's own category/priority/summary
    // controllers so they are included in ticket submission.
    ever(ai.analysis, (result) {
      if (result != null) {
        ticketController.categoryController.text = result.category;
        ticketController.priorityController.text = result.priority;
        ticketController.summaryController.text = result.aiSummary;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return UserLayout(
      title: 'Create Ticket',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Obx(() {
              final result = ai.analysis.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER SECTION ---
                  Text(
                    "Submit New Ticket",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Fill in the details below. Use our AI analyzer to auto-fill categories and tags.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- CORE FORM DETAILS ---
                  _buildFormSection(
                    title: "Ticket Details",
                    icon: Icons.assignment_outlined,
                    children: [
                      TextField(
                        controller: ticketController.titleController,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          hintText: "Briefly describe the issue",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: ticketController.descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          hintText: "Provide step-by-step details of the problem...",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- AI ASSIST TRIGGER ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: ai.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.smart_toy_outlined),
                      label: Text(
                        ai.isLoading.value ? "Analyzing Details..." : "Analyze with AI Smart Assist",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: ai.isLoading.value
                          ? null
                          : () {
                              ai.analyzeTicket(
                                title: ticketController.titleController.text,
                                description: ticketController.descriptionController.text,
                              );
                            },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- AI SMART METRICS DISPLAY ---
                  if (result != null) ...[
                    if (result.duplicate) ...[
                      Card(
                        elevation: 0,
                        color: theme.colorScheme.errorContainer,
                        margin: const EdgeInsets.only(bottom: 24),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: theme.colorScheme.error),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
                          title: Text(
                            "Possible duplicate ticket detected.",
                            style: TextStyle(color: theme.colorScheme.onErrorContainer, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            result.duplicateTicket?.title ?? "Identical submission active.",
                            style: TextStyle(color: theme.colorScheme.onErrorContainer),
                          ),
                        ),
                      ),
                    ],
                    _buildFormSection(
                      title: "AI Smart Categorization",
                      icon: Icons.auto_awesome_outlined,
                      children: [
                        if (isDesktop)
                          Row(
                            children: [
                              Expanded(child: _buildMetaField("Category", ticketController.categoryController, Icons.category_outlined)),
                              const SizedBox(width: 20),
                              Expanded(child: _buildMetaField("Priority", ticketController.priorityController, Icons.outlined_flag)),
                            ],
                          )
                        else ...[
                          _buildMetaField("Category", ticketController.categoryController, Icons.category_outlined),
                          const SizedBox(height: 20),
                          _buildMetaField("Priority", ticketController.priorityController, Icons.outlined_flag),
                        ],
                        const SizedBox(height: 20),
                        TextField(
                          controller: ticketController.summaryController,
                          maxLines: 3,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "AI Generated Summary",
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // --- ATTACHMENTS SECTION ---
                  _buildFormSection(
                    title: "Attachments",
                    icon: Icons.attach_file,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: upload.pickAndUpload,
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: const Text("Upload Supporting Files"),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: UploadProgress(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: upload.uploads.length,
                        itemBuilder: (_, i) => UploadCard(upload: upload.uploads[i]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // --- SUBMIT ACTION ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: ticketController.isLoading.value
                          ? null
                          : () async {
                              // Basic validation
                              if (ticketController.titleController.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Validation Error',
                                  'Please enter a ticket title.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              if (ticketController.descriptionController.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Validation Error',
                                  'Please enter a description.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              await ticketController.createTicket();
                            },
                      child: const Text(
                        "Submit Ticket",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({required String title, required IconData icon, required List<Widget> children}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        // ✅ Fixed
border: Border.all(
  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMetaField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
      ),
    );
  }
}


