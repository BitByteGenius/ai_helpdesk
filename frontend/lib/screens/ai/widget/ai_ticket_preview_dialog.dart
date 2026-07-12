import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.draft["title"]);
    _descriptionController = TextEditingController(text: widget.draft["description"]);
    
    // category/priority validation
    _selectedCategory = _categories.contains(widget.draft["category"])
        ? widget.draft["category"]
        : "Other";
    _selectedPriority = _priorities.contains(widget.draft["priority"])
        ? widget.draft["priority"]
        : "Medium";

    _uploadController = Get.find<UploadController>();
    _uploadController.clearUploads(); // clean state for new ticket
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
      Get.snackbar("Error", "Title and Description are required.");
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

      // Make create ticket request including admin metadata
      final ticket = await ticketService.createTicket(
        title: _titleController.text.trim(),
        description: finalDescription,
        category: _selectedCategory,
        priority: _selectedPriority,
        summary: widget.draft["summary"] ?? "",
        duplicateTicket: widget.draft["duplicate"] ?? false,
        attachments: uploadIds,
        aiConversationTranscript: transcript,
        aiConfidence: widget.draft["confidence"] ?? "Medium",
        aiSuggestedRootCause: widget.draft["possibleRootCause"] ?? "",
        aiTroubleshootingAttempted: widget.draft["troubleshootingAttempted"] ?? "",
        aiSuggestedReply: widget.draft["suggestedReply"] ?? "",
      );

      // Insert into local TicketController tickets list
      final ticketController = Get.find<TicketController>();
      ticketController.tickets.insert(0, ticket);

      Get.back(); // close dialog
      
      // Clear current chat conversation
      Get.find<AIChatController>().clearActiveConversation();

      Get.snackbar(
        "Ticket Created",
        "Your support ticket #${ticket.id.substring(0, 6)} has been created successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade800,
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
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Dialog(
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
                  Icon(Icons.assignment_outlined, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Submit Support Ticket",
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

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
                          color: theme.colorScheme.errorContainer.withOpacity(0.3),
                          border: Border.all(color: theme.colorScheme.error.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Potential Duplicate Detected",
                                    style: TextStyle(
                                      color: theme.colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.draft["duplicateTicket"]?["title"] ??
                                        "Similar ticket is active on dashboard.",
                                    style: TextStyle(
                                      color: theme.colorScheme.onErrorContainer.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── AI Copilot Metadata Highlights (Category/Priority/Cause) ──
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome, size: 18, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                "AI Assist Classification Insights",
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (isDesktop)
                            Row(
                              children: [
                                Expanded(child: _buildInfoTag("Suggested Root Cause", widget.draft["possibleRootCause"] ?? "Unknown")),
                                const SizedBox(width: 16),
                                Expanded(child: _buildInfoTag("Assignment Team", widget.draft["recommendedAssignmentTeam"] ?? "Support")),
                              ],
                            )
                          else ...[
                            _buildInfoTag("Suggested Root Cause", widget.draft["possibleRootCause"] ?? "Unknown"),
                            const SizedBox(height: 10),
                            _buildInfoTag("Assignment Team", widget.draft["recommendedAssignmentTeam"] ?? "Support"),
                          ],
                          const SizedBox(height: 10),
                          _buildInfoTag("Troubleshooting Attempted", widget.draft["troubleshootingAttempted"] ?? "None identified"),
                        ],
                      ),
                    ),

                    // ── Ticket Editable Title ──
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Ticket Title",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
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
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: "Issue Description",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Conversation Transcript Toggle ──
                    CheckboxListTile(
                      title: const Text("Include full chat transcript in description"),
                      subtitle: const Text("Appends user & AI replies for agent review"),
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
                    Text("Attachments (Optional)", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _uploadController.pickAndUpload,
                            icon: const Icon(Icons.cloud_upload_outlined),
                            label: const Text("Add Supporting Files"),
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
            const Divider(height: 1),

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
                        : const Icon(Icons.check),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          children: [
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: "Category",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category_outlined),
      ),
      items: _categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
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
      value: _selectedPriority,
      decoration: const InputDecoration(
        labelText: "Priority",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.flag_outlined),
      ),
      items: _priorities
          .map((prio) => DropdownMenuItem(value: prio, child: Text(prio)))
          .toList(),
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
