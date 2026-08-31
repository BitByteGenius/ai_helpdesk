import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ai_model/chat_message_model.dart';
import 'package:frontend/servicies/ticket_service.dart';
import 'package:frontend/screens/uploads/widget/upload_card.dart';
import 'package:frontend/screens/uploads/widget/upload_progress.dart';
import 'package:get/get.dart';

class AITicketPreviewDialog extends StatefulWidget {
  final Map<String, dynamic> draft;
  final List<ChatMessageModel> chatMessages;

  const AITicketPreviewDialog({
    super.key,
    required this.draft,
    required this.chatMessages,
  });

  @override
  State<AITicketPreviewDialog> createState() => _AITicketPreviewDialogState();
}

class _AITicketPreviewDialogState extends State<AITicketPreviewDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late String _selectedCategory;
  late String _selectedPriority;
  bool _includeTranscript = true;
  bool _isSubmitting = false;

  final List<String> _categories = [
    "Hardware",
    "Software",
    "Network",
    "Email",
    "Security",
    "Account",
    "Printer",
    "Internet",
    "Other"
  ];

  final List<String> _priorities = ["Low", "Medium", "High", "Critical"];

  late final UploadController _uploadController;

  static String _safeString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join("\n• ");
    return val.toString();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: _safeString(widget.draft["title"]));
    _descriptionController = TextEditingController(text: _safeString(widget.draft["description"]));

    final categoryStr = _safeString(widget.draft["category"], fallback: "Other");
    _selectedCategory = _categories.contains(categoryStr) ? categoryStr : "Other";

    final priorityStr = _safeString(widget.draft["priority"], fallback: "Medium");
    _selectedPriority = _priorities.contains(priorityStr) ? priorityStr : "Medium";

    _uploadController = Get.find<UploadController>();
    _uploadController.clearUploads();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _generateTranscriptText() {
    return widget.chatMessages
        .map((m) => "${m.role == 'user' ? 'User' : 'AI Assistant'}: ${m.message}")
        .join("\n\n");
  }

  Future<void> _submitTicket() async {
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      Get.snackbar("Error", "Title and Description are required.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final transcript = _generateTranscriptText();
      String finalDescription = _descriptionController.text.trim();

      if (_includeTranscript) {
        finalDescription += "\n\n=== Conversation Transcript ===\n$transcript";
      }

      final ticketService = Get.find<TicketService>();
      final uploadIds = _uploadController.uploads.map((e) => e.id).toList();

      final ticket = await ticketService.createTicket(
        title: _titleController.text.trim(),
        description: finalDescription,
        category: _selectedCategory,
        priority: _selectedPriority,
        summary: _safeString(widget.draft["summary"]),
        duplicateTicket: widget.draft["duplicate"] == true,
        attachments: uploadIds,
        aiConversationTranscript: transcript,
        aiConfidence: _safeString(widget.draft["confidence"], fallback: "Medium"),
        aiSuggestedRootCause: _safeString(widget.draft["possibleRootCause"]),
        aiTroubleshootingAttempted: _safeString(widget.draft["troubleshootingAttempted"]),
        aiSuggestedReply: _safeString(widget.draft["suggestedReply"]),
      );

      final ticketController = Get.find<TicketController>();
      ticketController.tickets.insert(0, ticket);

      Get.back();

      Get.find<AIChatController>().clearActiveConversation();

      Get.snackbar(
        "Ticket Created",
        "Your support ticket #${ticket.id.length > 6 ? ticket.id.substring(ticket.id.length - 6) : ticket.id} has been created successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Submission Failed",
        "Failed to submit ticket: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Dialog(
      backgroundColor: context.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 750,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          children: [
            // ── Dialog Header ──
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.primarySubtle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.confirmation_number_outlined, color: context.primaryColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Submit Support Ticket",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: context.textPrimary),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: context.borderLight),

            // ── Dialog Scrollable Fields ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── AI Summary & Duplicate Alert ──
                    if (widget.draft["duplicate"] == true) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: context.isDark ? 0.15 : 0.08),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Potential Duplicate Detected",
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _safeString(widget.draft["duplicateTicket"] is Map
                                        ? widget.draft["duplicateTicket"]["title"]
                                        : widget.draft["duplicateTicket"], fallback: "Similar ticket is active on dashboard."),
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── AI Copilot Metadata Highlights ──
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.surfaceSubtle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome_rounded, size: 16, color: context.primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                "AI Copilot Insights",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (isDesktop)
                            Row(
                              children: [
                                Expanded(child: _buildInfoTag("Suggested Root Cause", _safeString(widget.draft["possibleRootCause"], fallback: "Unknown"))),
                                const SizedBox(width: 16),
                                Expanded(child: _buildInfoTag("Assignment Team", _safeString(widget.draft["recommendedAssignmentTeam"], fallback: "Support"))),
                              ],
                            )
                          else ...[
                            _buildInfoTag("Suggested Root Cause", _safeString(widget.draft["possibleRootCause"], fallback: "Unknown")),
                            const SizedBox(height: 10),
                            _buildInfoTag("Assignment Team", _safeString(widget.draft["recommendedAssignmentTeam"], fallback: "Support")),
                          ],
                          const SizedBox(height: 10),
                          _buildInfoTag("Troubleshooting Attempted", _safeString(widget.draft["troubleshootingAttempted"], fallback: "None identified")),
                        ],
                      ),
                    ),

                    // ── Ticket Editable Title ──
                    TextField(
                      controller: _titleController,
                      style: TextStyle(color: context.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: "Ticket Title",
                        prefixIcon: Icon(Icons.title_rounded, size: 18),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Category and Priority Selectors ──
                    if (isDesktop)
                      Row(
                        children: [
                          Expanded(child: _buildCategoryDropdown()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildPriorityDropdown()),
                        ],
                      )
                    else ...[
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),
                      _buildPriorityDropdown(),
                    ],
                    const SizedBox(height: 16),

                    // ── Ticket Editable Description ──
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      style: TextStyle(color: context.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: "Issue Description",
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Conversation Transcript Toggle ──
                    CheckboxListTile(
                      title: Text("Include full chat transcript in description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
                      subtitle: Text("Appends conversation history for the support engineer", style: TextStyle(fontSize: 12, color: context.textSecondary)),
                      value: _includeTranscript,
                      onChanged: (val) {
                        setState(() {
                          _includeTranscript = val ?? true;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),

                    // ── Attachments Upload UI ──
                    Text("Attachments (Optional)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary)),
                    const SizedBox(height: 8),
                    Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              side: BorderSide(color: context.border),
                            ),
                            onPressed: _uploadController.pickAndUpload,
                            icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                            label: const Text("Add Files", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: UploadProgress(),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _uploadController.uploads.length,
                            itemBuilder: (_, i) => UploadCard(upload: _uploadController.uploads[i]),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: context.borderLight),

            // ── Dialog Footer Actions ──
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submitTicket,
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_rounded, size: 18),
                    label: const Text("Submit Ticket"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: TextStyle(fontWeight: FontWeight.w700, color: context.textPrimary, fontSize: 12),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(fontWeight: FontWeight.normal, color: context.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      dropdownColor: context.cardBg,
      style: TextStyle(color: context.textPrimary, fontSize: 13),
      decoration: const InputDecoration(
        labelText: "Category",
        prefixIcon: Icon(Icons.category_outlined, size: 18),
      ),
      items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedCategory = val;
          });
        }
      },
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedPriority,
      dropdownColor: context.cardBg,
      style: TextStyle(color: context.textPrimary, fontSize: 13),
      decoration: const InputDecoration(
        labelText: "Priority",
        prefixIcon: Icon(Icons.outlined_flag_rounded, size: 18),
      ),
      items: _priorities.map((prio) => DropdownMenuItem(value: prio, child: Text(prio, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedPriority = val;
          });
        }
      },
    );
  }
}
