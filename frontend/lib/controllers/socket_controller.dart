import 'package:frontend/servicies/socket_service.dart';
import 'package:get/get.dart';


class SocketController extends GetxController {
  final SocketService _socket = SocketService.instance;

  /// Connection Status
  final RxBool isConnected = false.obs;

  /// Current User ID
  final RxString currentUserId = "".obs;

  @override
  void onInit() {
    super.onInit();
    _listenConnection();
  }

  /// Connect Socket
  void connect(String userId) {
    currentUserId.value = userId;

    _socket.connect();

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        join(userId);
      },
    );
  }

  /// Join User
  void join(String userId) {
    _socket.join(userId);
  }

  /// Disconnect
  void disconnect() {
    _socket.disconnect();

    isConnected.value = false;
  }

  /// Connection Events
  void _listenConnection() {
    _socket.listen(
      "connect",
      (_) {
        isConnected.value = true;

        if (currentUserId.isNotEmpty) {
          join(currentUserId.value);
        }
      },
    );

    _socket.listen(
      "disconnect",
      (_) {
        isConnected.value = false;
      },
    );
  }

  /// Notification Event
  void onNotification(
    Function(dynamic data) callback,
  ) {
    _socket.listen(
      "notification",
      callback,
    );
  }

  /// Ticket Created
  void onTicketCreated(
    Function(dynamic data) callback,
  ) {
    _socket.listen(
      "ticket-created",
      callback,
    );
  }

  /// Ticket Updated
  void onTicketUpdated(
    Function(dynamic data) callback,
  ) {
    _socket.listen(
      "ticket-updated",
      callback,
    );
  }

  /// Ticket Assigned
  void onTicketAssigned(
    Function(dynamic data) callback,
  ) {
    _socket.listen(
      "ticket-assigned",
      callback,
    );
  }

  /// Ticket Status
  void onTicketStatus(
    Function(dynamic data) callback,
  ) {
    _socket.listen(
      "ticket-status",
      callback,
    );
  }

  /// Comment Added
  void onCommentAdded(
    Function(dynamic data) callback,
  ) {
    _socket.listen(
      "comment-added",
      callback,
    );
  }

  /// Dashboard Updated
  void onDashboardUpdated(
    Function(dynamic data) callback,
  ) {
    _socket.listen(
      "dashboard-updated",
      callback,
    );
  }

  /// Remove Listener
  void remove(String event) {
    _socket.remove(event);
  }

  /// Remove All Listeners
  void removeAll() {
    _socket.removeAll();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}