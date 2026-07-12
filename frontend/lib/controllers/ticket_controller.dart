import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/servicies/ticket_service.dart';
import 'package:get/get.dart';

import '../models/ticket_model.dart';

class TicketController extends GetxController {
  final TicketService _service;

  TicketController(this._service);

  /// Loading
  final RxBool isLoading = false.obs;

  /// Error
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;

  /// Tickets
  final RxList<TicketModel> tickets = <TicketModel>[].obs;

  /// Selected Ticket
  final Rxn<TicketModel> selectedTicket = Rxn<TicketModel>();

  /// Search
  final TextEditingController searchController =
      TextEditingController();

  /// Create Ticket Form
  final TextEditingController titleController =
      TextEditingController();
  final TextEditingController descriptionController =
      TextEditingController();
  final TextEditingController categoryController =
      TextEditingController();
  final TextEditingController priorityController =
      TextEditingController();
  final TextEditingController summaryController =
      TextEditingController();

  /// Filters
  final RxString selectedStatus = "".obs;
  final RxString selectedPriority = "".obs;
  final RxString selectedCategory = "".obs;

  /// Pagination
  final RxInt page = 1.obs;
  final RxInt limit = 10.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }
@override
void onClose() {
  searchController.dispose();

  titleController.dispose();
  descriptionController.dispose();
  categoryController.dispose();
  priorityController.dispose();
  summaryController.dispose();

  super.onClose();
}

  /// Fetch Tickets
  Future<void> fetchTickets() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final data = await _service.getTickets(
        page: page.value,
        limit: limit.value,
        search: searchController.text,
        status: selectedStatus.value.isEmpty
            ? null
            : selectedStatus.value,
        priority: selectedPriority.value.isEmpty
            ? null
            : selectedPriority.value,
        category: selectedCategory.value.isEmpty
            ? null
            : selectedCategory.value,
      );

      tickets.assignAll(data);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh
  Future<void> refreshTickets() async {
    await fetchTickets();
  }

  /// Search
  Future<void> searchTickets(String value) async {
    searchController.text = value;
    await fetchTickets();
  }

  /// Filter Status
  Future<void> filterStatus(String value) async {
    selectedStatus.value = value;
    await fetchTickets();
  }

  /// Filter Priority
  Future<void> filterPriority(String value) async {
    selectedPriority.value = value;
    await fetchTickets();
  }

  /// Filter Category
  Future<void> filterCategory(String value) async {
    selectedCategory.value = value;
    await fetchTickets();
  }

  /// Clear Filters
  Future<void> clearFilters() async {
    searchController.clear();
    selectedStatus.value = "";
    selectedPriority.value = "";
    selectedCategory.value = "";

    await fetchTickets();
  }

  /// Ticket Details
  Future<void> getTicket(String id) async {
    try {
      isLoading.value = true;

      selectedTicket.value =
          await _service.getTicket(id);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Ticket
  Future<void> deleteTicket(String id) async {
    try {
      await _service.deleteTicket(id);

      tickets.removeWhere(
        (e) => e.id == id,
      );

      Get.snackbar(
        "Success",
        "Ticket deleted successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// Assign Ticket
  Future<void> assignTicket({
    required String ticketId,
    required String userId,
  }) async {
    try {
      final updated =
          await _service.assignTicket(
        ticketId: ticketId,
        assignedTo: userId,
      );

      final index =
          tickets.indexWhere(
        (e) => e.id == ticketId,
      );

      if (index != -1) {
        tickets[index] = updated;
      }

      selectedTicket.value = updated;

      Get.snackbar(
        "Success",
        "Ticket assigned successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// Update Status
  Future<void> updateStatus({
    required String ticketId,
    required String status,
  }) async {
    try {
      final updated =
          await _service.updateStatus(
        ticketId: ticketId,
        status: status,
      );

      final index =
          tickets.indexWhere(
        (e) => e.id == ticketId,
      );

      if (index != -1) {
        tickets[index] = updated;
      }

      selectedTicket.value = updated;

      Get.snackbar(
        "Success",
        "Status updated successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// Create Ticket
Future<void> createTicket() async {
  try {
    isLoading.value = true;

    final ai = Get.find<AiController>();
    final upload = Get.find<UploadController>();

    final analysis = ai.analysis.value;

    final uploadIds = upload.uploads
        .map((e) => e.id)
        .toList();

    final ticket = await _service.createTicket(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: (analysis?.category.isNotEmpty == true
              ? analysis!.category
              : categoryController.text.trim().isNotEmpty
                  ? categoryController.text.trim()
                  : "Other"),
      priority: (analysis?.priority.isNotEmpty == true
              ? analysis!.priority
              : priorityController.text.trim().isNotEmpty
                  ? priorityController.text.trim()
                  : "Medium"),
      summary: analysis?.aiSummary ??
          summaryController.text.trim(),
      duplicateTicket:
          analysis?.duplicate ?? false,
      attachments: uploadIds,
    );

    tickets.insert(0, ticket);

    titleController.clear();
    descriptionController.clear();
    categoryController.clear();
    priorityController.clear();
    summaryController.clear();

    upload.clearUploads();
    ai.clearAnalysis();

    Get.snackbar(
      "Success",
      "Ticket created successfully",
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
  }
}


}