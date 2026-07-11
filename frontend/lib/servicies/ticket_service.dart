import 'package:frontend/servicies/api_service.dart';
import 'package:dio/dio.dart';
import '../models/ticket_model.dart';

class TicketService {
  // Use the singleton ApiService Dio — it has baseUrl, auth interceptor, timeouts.
  final Dio _dio = ApiService.instance.dio;

  /// Get All Tickets (Admin → all; User → own)
  Future<List<TicketModel>> getTickets({
    int page = 1,
    int limit = 10,
    String search = "",
    String? status,
    String? priority,
    String? category,
  }) async {
    try {
      final response = await _dio.get(
        "tickets",
        queryParameters: {
          "page": page,
          "limit": limit,
          if (search.isNotEmpty) "search": search,
          if (status != null && status.isNotEmpty) "status": status,
          if (priority != null && priority.isNotEmpty) "priority": priority,
          if (category != null && category.isNotEmpty) "category": category,
        },
      );

      final List data = response.data["data"];

      return data.map((e) => TicketModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to fetch tickets",
      );
    }
  }

  /// Get Ticket Details
  Future<TicketModel> getTicket(String id) async {
    try {
      final response = await _dio.get("tickets/$id");

      return TicketModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to fetch ticket",
      );
    }
  }

  /// Create Ticket
  Future<TicketModel> createTicket({
    required String title,
    required String description,
    required String category,
    required String priority,
    String summary = "",
    bool duplicateTicket = false,
    List<String> attachments = const [],
  }) async {
    try {
      final response = await _dio.post(
        "tickets",
        data: {
          "title": title,
          "description": description,
          "category": category,
          "priority": priority,
          "summary": summary,
          "duplicateTicket": duplicateTicket,
          "attachments": attachments,
        },
      );

      return TicketModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to create ticket",
      );
    }
  }

  /// Update Ticket
  Future<TicketModel> updateTicket({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.put("tickets/$id", data: data);

      return TicketModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to update ticket",
      );
    }
  }

  /// Delete Ticket
  Future<void> deleteTicket(String id) async {
    try {
      await _dio.delete("tickets/$id");
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to delete ticket",
      );
    }
  }

  /// Assign Ticket
  Future<TicketModel> assignTicket({
    required String ticketId,
    required String assignedTo,
  }) async {
    try {
      final response = await _dio.put(
        "tickets/$ticketId/assign",
        data: {"assignedTo": assignedTo},
      );

      return TicketModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to assign ticket",
      );
    }
  }

  /// Update Ticket Status
  Future<TicketModel> updateStatus({
    required String ticketId,
    required String status,
  }) async {
    try {
      final response = await _dio.put(
        "tickets/$ticketId/status",
        data: {"status": status},
      );

      return TicketModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to update status",
      );
    }
  }

  /// Close Ticket
  Future<TicketModel> closeTicket(String ticketId) async {
    return updateStatus(ticketId: ticketId, status: "Closed");
  }

  /// Reopen Ticket
  Future<TicketModel> reopenTicket(String ticketId) async {
    return updateStatus(ticketId: ticketId, status: "Open");
  }

  /// Dashboard Summary (kept for backward compat)
  Future<Map<String, dynamic>> dashboard() async {
    final response = await _dio.get("dashboard");
    return response.data["data"];
  }
}