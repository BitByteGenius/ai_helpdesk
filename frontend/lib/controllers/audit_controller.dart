import 'package:flutter/foundation.dart';
import 'package:frontend/servicies/audit_service.dart';
import 'package:get/get.dart';

import '../models/audit_model.dart';

class AuditController extends GetxController {
  final AuditService _service;

  AuditController(this._service);

  final RxBool isLoading = false.obs;

  final RxList<AuditModel> audits =
      <AuditModel>[].obs;

  final Rxn<AuditModel> selectedAudit =
      Rxn<AuditModel>();

  final RxString selectedAction = "".obs;
  final RxString selectedEntity = "".obs;
  final RxString selectedUser = "".obs;

  final RxInt page = 1.obs;
  final RxInt limit = 20.obs;

  final RxList<AuditModel> ticketAudits = <AuditModel>[].obs;
  final RxBool isLoadingTicketAudits = false.obs;

  Future<void> fetchTicketAudits(String ticketId) async {
    try {
      isLoadingTicketAudits.value = true;
      final logs = await _service.getEntityAudit(
        entity: "TICKET",
        entityId: ticketId,
      );
      ticketAudits.assignAll(logs);
    } catch (e) {
      debugPrint("Failed to fetch ticket audits: $e");
    } finally {
      isLoadingTicketAudits.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAudits();
  }

  Future<void> fetchAudits() async {
    try {
      isLoading.value = true;

      audits.assignAll(
        await _service.getAudits(
          page: page.value,
          limit: limit.value,
          action: selectedAction.value,
          entity: selectedEntity.value,
          user: selectedUser.value,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openAudit(
    String id,
  ) async {
    selectedAudit.value =
        await _service.getAudit(id);
  }

  Future<void> filterAction(
      String value) async {
    selectedAction.value = value;
    await fetchAudits();
  }

  Future<void> filterEntity(
      String value) async {
    selectedEntity.value = value;
    await fetchAudits();
  }

  Future<void> clearFilters() async {
    selectedAction.value = "";
    selectedEntity.value = "";
    selectedUser.value = "";
    await fetchAudits();
  }
}