import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/uploads/widget/upload_card.dart';
import 'package:frontend/screens/uploads/widget/upload_progress.dart';
import 'package:get/get.dart';



class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() =>
      _CreateTicketScreenState();
}

class _CreateTicketScreenState
    extends State<CreateTicketScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  final _category = TextEditingController();
  final _priority = TextEditingController();
  final _summary = TextEditingController();

  final ai = Get.find<AiController>();
  final upload = Get.find<UploadController>();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _category.dispose();
    _priority.dispose();
    _summary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width > 900;

    return UserLayout(
      title: 'Create Ticket',
      child: Obx(() {
        final result = ai.analysis.value;

        if (result != null) {
          _category.text = result.category;
          _priority.text = result.priority;
          _summary.text = result.summary;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 900,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: "Title",
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _description,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.smart_toy),
                      label: ai.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text("Analyze with AI"),
                      onPressed: ai.isLoading.value
                          ? null
                          : () {
                              ai.analyzeTicket(
                                title: _title.text,
                                description:
                                    _description.text,
                              );
                            },
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (result != null &&
                      result.duplicate)

                    Card(
                      color: Colors.orange.shade100,
                      child: ListTile(
                        leading: const Icon(
                          Icons.warning,
                          color: Colors.orange,
                        ),
                        title: const Text(
                          "Possible duplicate ticket detected.",
                        ),
                        subtitle: Text(
                          result.duplicateTicket?.title ??
                              "",
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  desktop
                      ? Row(
                          children: [

                            Expanded(
                              child: TextField(
                                controller: _category,
                                decoration:
                                    const InputDecoration(
                                  labelText:
                                      "Category",
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: TextField(
                                controller: _priority,
                                decoration:
                                    const InputDecoration(
                                  labelText:
                                      "Priority",
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [

                            TextField(
                              controller: _category,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    "Category",
                              ),
                            ),

                            const SizedBox(height: 20),

                            TextField(
                              controller: _priority,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    "Priority",
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _summary,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "AI Summary",
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Attachments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed:
                        upload.pickAndUpload,
                    icon: const Icon(
                      Icons.upload,
                    ),
                    label:
                        const Text("Upload File"),
                  ),

                  const UploadProgress(),

                  const SizedBox(height: 20),

                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          upload.uploads.length,
                      itemBuilder: (_, i) =>
                          UploadCard(
                        upload:
                            upload.uploads[i],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {

                        /// Next Step:
                        /// Call TicketController.createTicket()

                      },
                      child: const Text(
                        "Create Ticket",
                      ),
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
}
