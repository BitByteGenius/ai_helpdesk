import 'package:dio/dio.dart';
import 'package:frontend/servicies/api_service.dart';

import '../models/audit_model.dart';

class AuditService {
  final Dio _dio;

  AuditService([Dio? dio]) : _dio = dio ?? ApiService.instance.dio;

  /// Get Audit Logs
  Future<List<AuditModel>> getAudits({
    int page = 1,
    int limit = 20,
    String? action,
    String? entity,
    String? user,
  }) async {
    try {
      final response = await _dio.get(
        "audit",
        queryParameters: {
          "page": page,
          "limit": limit,
          if (action != null && action.isNotEmpty)
            "action": action,
          if (entity != null && entity.isNotEmpty)
            "entity": entity,
          if (user != null && user.isNotEmpty)
            "user": user,
        },
      );

      final List data = response.data["logs"];

      return data
          .map((e) => AuditModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch audit logs",
      );
    }
  }

  /// Get Audit Details
  Future<AuditModel> getAudit(
    String id,
  ) async {
    try {
      final response = await _dio.get(
        "audit/$id",
      );

      return AuditModel.fromJson(
        response.data["data"],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch audit",
      );
    }
  }

  /// User Audit
  Future<List<AuditModel>> getUserAudit(
    String userId,
  ) async {
    try {
      final response = await _dio.get(
        "audit/user/$userId",
      );

      final List data = response.data["data"];

      return data
          .map((e) => AuditModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch user audit",
      );
    }
  }

  /// Entity Audit
  Future<List<AuditModel>> getEntityAudit({
    required String entity,
    required String entityId,
  }) async {
    try {
      final response = await _dio.get(
        "audit/entity/$entity/$entityId",
      );

      final List data = response.data["data"];

      return data
          .map((e) => AuditModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch entity audit",
      );
    }
  }
}
