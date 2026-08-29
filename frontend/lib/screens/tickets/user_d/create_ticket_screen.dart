import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
  late final TicketController ticketController;
  late final AiController ai;
  late final UploadController upload;
  late final Worker _analysisWorker;

  @override
  void initState() {
    super.initState();
    ticketController = Get.find<TicketController>();
    ai = Get.find<AiController>();
    upload = Get.find<UploadController>();

    _analysisWorker = ever(ai.analysis, (result) {
      if (result != null) {
        if (!mounted) return;
        ticketController.categoryController.text = result.category;
        ticketController.priorityController.text = result.priority;
        ticketController.summaryController.text = result.aiSummary;
      }
    });
  }

  @override
  void dispose() {
    _analysisWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'Create Ticket',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Obx(() {
                  final result = ai.analysis.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──
                      Text(
                        "Submit Support Ticket",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Fill in the details below. Our AI assistant will automatically classify and suggest priority.",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Ticket Details Form ──
                      _buildFormSection(
                        title: "Issue Details",
                        icon: Icons.edit_note_rounded,
                        children: [
                          TextField(
                            controller: ticketController.titleController,
                            decoration: const InputDecoration(
                              labelText: "Subject / Title",
                              hintText: "E.g. Unable to connect to VPN server",
                              prefixIcon: Icon(Icons.title_rounded, size: 18),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: ticketController.descriptionController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              labelText: "Detailed Description",
                              hintText: "Explain what happened, steps to reproduce, and any error codes...",
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── AI Assist Button ──
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.tonalIcon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primarySubtle,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: ai.isLoading.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.auto_awesome_rounded, size: 18),
                          label: Text(
                            ai.isLoading.value ? "Analyzing with AI..." : "Auto-Categorize with AI Copilot",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
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
                      const SizedBox(height: 20),

                      // ── AI Smart Results ──
                      if (result != null) ...[
                        if (result.duplicate) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.errorSubtle,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Possible Duplicate Ticket Detected",
                                        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        result.duplicateTicket?.title ?? "An identical ticket was recently submitted.",
                                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        _buildFormSection(
                          title: "AI Smart Classification",
                          icon: Icons.auto_awesome_rounded,
                          children: [
                            if (isDesktop)
                              Row(
                                children: [
                                  Expanded(child: _buildMetaField("Category", ticketController.categoryController, Icons.category_outlined)),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildMetaField("Priority", ticketController.priorityController, Icons.outlined_flag_rounded)),
                                ],
                              )
                            else ...[
                              _buildMetaField("Category", ticketController.categoryController, Icons.category_outlined),
                              const SizedBox(height: 16),
                              _buildMetaField("Priority", ticketController.priorityController, Icons.outlined_flag_rounded),
                            ],
                            const SizedBox(height: 16),
                            TextField(
                              controller: ticketController.summaryController,
                              maxLines: 3,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "AI Generated Summary",
                                filled: true,
                                fillColor: AppColors.surfaceSubtle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ── Attachments ──
                      _buildFormSection(
                        title: "Supporting Files",
                        icon: Icons.attach_file_rounded,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            onPressed: upload.pickAndUpload,
                            icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                            label: const Text("Upload Files (PDF, Image, Logs)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                      const SizedBox(height: 32),

                      // ── Submit Button ──
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: ticketController.isLoading.value
                              ? null
                              : () async {
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
                            "Submit Support Ticket",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor: AppColors.surfaceSubtle,
      ),
    );
  }
}



