import 'package:dio/dio.dart';
import 'package:frontend/core/constant/api_constant.dart';
import 'package:frontend/models/darshboard_model.dart';
import 'package:frontend/servicies/api_service.dart';



class DashboardService {
  final Dio _dio = ApiService.instance.dio;

  Future<DashboardModel> getDashboard() async {
    try {
      final response = await _dio.get(
        ApiConstants.dashboard,
      );

      return DashboardModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return DashboardModel(
          users: UserStats(total: 0, active: 0, inactive: 0),
          tickets: TicketStats(
            total: 0,
            open: 0,
            assigned: 0,
            inProgress: 0,
            resolved: 0,
            closed: 0,
          ),
          priority: PriorityStats(
            low: 0,
            medium: 0,
            high: 0,
            critical: 0,
          ),
          status: StatusStats(
            open: 0,
            assigned: 0,
            inProgress: 0,
            resolved: 0,
            closed: 0,
          ),
          recentTickets: const [],
          recentUsers: const [],
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
