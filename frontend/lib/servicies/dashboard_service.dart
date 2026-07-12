import 'package:dio/dio.dart';
import 'package:frontend/core/constant/api_constant.dart';
import 'package:frontend/models/dashboard_model.dart';
import 'package:frontend/servicies/api_service.dart';

class DashboardService {
  final Dio _dio = ApiService.instance.dio;

  Future<DashboardModel> getDashboard() async {
    try {
      final response = await _dio.get(
        ApiConstants.dashboard,
      );

      return DashboardModel.fromJson(
        response.data["data"] ?? {},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return DashboardModel(
          stats: DashboardStats(
            totalTickets: 0,
            open: 0,
            resolved: 0,
            users: 0,
          ),
          ticketStatus: const {},
          priority: const {},
          recentTickets: const [],
          recentUsers: const [],
          aiInsights: AiInsights(
            totalAnalysis: 0,
            duplicates: 0,
            suggestedReplies: 0,
          ),
        );
      }

      throw Exception(
        e.response?.data["message"] ??
            "Failed to load dashboard",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}