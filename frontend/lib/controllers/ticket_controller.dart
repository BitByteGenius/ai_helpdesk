import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_controller.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/servicies/ticket_service.dart';
import 'package:get/get.dart';

import '../models/ticket_model.dart';

class TicketController extends GetxController {
  final TicketService _service;

  TicketController(this._service);

  /// Loading
  final RxBool isLoading = false.obs;

  /// Updating
  final RxBool isUpdating = false.obs;

  /// Error
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;

  /// Tickets
  final RxList<TicketModel> tickets = <TicketModel>[].obs;

  /// My Tickets (all own tickets, unpaginated)
  final RxList<TicketModel> myTickets = <TicketModel>[].obs;

  /// Stats Getters for User Dashboard
  int get totalTicketsCount => myTickets.length;
  int get openTicketsCount => myTickets.where((t) => t.status == "Open").length;
  int get inProgressTicketsCount => myTickets.where((t) => t.status == "In Progress" || t.status == "Assigned").length;
  int get resolvedTicketsCount => myTickets.where((t) => t.status == "Resolved").length;

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

  void _showSnackbarSafe(
    String title,
    String message, {
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        Get.snackbar(
          title,
          message,
          snackPosition: snackPosition,
        );
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
    fetchMyTickets();
  }
@override
void onClose() {
  // Dispose of controllers that are tied to the lifecycle of this controller.
  // The form TextEditingControllers are used across screens and should remain alive.
  // Commenting out disposals to prevent "used after being disposed" errors.
  // searchController.dispose(); // keep if not needed globally
  // titleController.dispose();
  // descriptionController.dispose();
  // descriptionController.dispose();
  // categoryController.dispose();
  // priorityController.dispose();
  // summaryController.dispose();

  super.onClose();
}

  /// Fetch all user tickets for stats
  Future<void> fetchMyTickets() async {
    try {
      final data = await _service.getMyTickets();
      myTickets.assignAll(data);
    } catch (e) {
      debugPrint("Error fetching my tickets: $e");
    }
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
    await Future.wait([
      fetchTickets(),
      fetchMyTickets(),
    ]);
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
      _showSnackbarSafe("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Ticket
  Future<void> deleteTicket(String id) async {
    try {
      isUpdating.value = true;
      await _service.deleteTicket(id);

      tickets.removeWhere(
        (e) => e.id == id,
      );
      myTickets.removeWhere(
        (e) => e.id == id,
      );

      _showSnackbarSafe("Success", "Ticket deleted successfully");
    } catch (e) {
      _showSnackbarSafe("Error", e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  /// Assign Ticket
  Future<void> assignTicket(String ticketId, [String? userId]) async {
    final targetUserId = userId ?? Get.find<AuthController>().user?.id;
    if (targetUserId == null) {
      _showSnackbarSafe("Error", "No user specified and no logged-in user found.");
      return;
    }
    try {
      isUpdating.value = true;
      final updated = await _service.assignTicket(
        ticketId: ticketId,
        assignedTo: targetUserId,
      );

      final index = tickets.indexWhere(
        (e) => e.id == ticketId,
      );

      if (index != -1) {
        tickets[index] = updated;
      }

      final myIndex = myTickets.indexWhere(
        (e) => e.id == ticketId,
      );

      if (myIndex != -1) {
        myTickets[myIndex] = updated;
      }

      selectedTicket.value = updated;

      _showSnackbarSafe("Success", "Ticket assigned successfully");
    } catch (e) {
      _showSnackbarSafe("Error", e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update Status
  Future<void> updateStatus(String ticketId, String status) async {
    try {
      isUpdating.value = true;
      final updated = await _service.updateStatus(
        ticketId: ticketId,
        status: status,
      );

      final index = tickets.indexWhere(
        (e) => e.id == ticketId,
      );

      if (index != -1) {
        tickets[index] = updated;
      }

      final myIndex = myTickets.indexWhere(
        (e) => e.id == ticketId,
      );

      if (myIndex != -1) {
        myTickets[myIndex] = updated;
      }

      selectedTicket.value = updated;

      _showSnackbarSafe("Success", "Status updated successfully");
    } catch (e) {
      _showSnackbarSafe("Error", e.toString());
    } finally {
      isUpdating.value = false;
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
    myTickets.insert(0, ticket);

    titleController.clear();
    descriptionController.clear();
    categoryController.clear();
    priorityController.clear();
    summaryController.clear();

    upload.clearUploads();
    ai.clearAnalysis();

    _showSnackbarSafe(
      "Success",
      "Ticket created successfully",
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
