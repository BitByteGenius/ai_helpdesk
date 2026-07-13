import 'package:frontend/servicies/socket_service.dart';
import 'package:get/get.dart';

class SocketController extends GetxController {
  final SocketService _socket = SocketService.instance;

  /// Whether the socket is currently connected
  final RxBool isConnected = false.obs;

  /// The current user ID (used to rejoin after reconnection)
  final RxString currentUserId = "".obs;

  /// Whether the current user is an admin
  final RxBool isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenConnection();
  }

  /// Connect socket and join personal room
  void connect(String userId, {bool admin = false}) {
    currentUserId.value = userId;
    isAdmin.value = admin;

    _socket.connect();

    // Join after a brief delay to ensure connection is established
    Future.delayed(const Duration(milliseconds: 500), () {
      join(userId);
      if (admin) {
        _socket.joinAdminRoom();
      }
    });
  }

  /// Join personal notification room
  void join(String userId) {
    _socket.join(userId);
  }

  /// Disconnect
  void disconnect() {
    _socket.disconnect();
    isConnected.value = false;
  }

  /// Join a ticket room (for real-time comment updates)
  void joinTicketRoom(String ticketId) {
    _socket.joinTicketRoom(ticketId);
  }

  /// Leave a ticket room
  void leaveTicketRoom(String ticketId) {
    _socket.leaveTicketRoom(ticketId);
  }

  // ── Connection Lifecycle ─────────────────────────────────────────────────

  void _listenConnection() {
    _socket.listen("connect", (_) {
      isConnected.value = true;
      // Rejoin rooms after reconnection
      if (currentUserId.isNotEmpty) {
        join(currentUserId.value);
        if (isAdmin.value) {
          _socket.joinAdminRoom();
        }
      }
    });

    _socket.listen("disconnect", (_) {
      isConnected.value = false;
    });
  }

  // ── Event Subscriptions ──────────────────────────────────────────────────

  /// Real-time notification — backend emits "notification:new"
  void onNotification(Function(dynamic data) callback) {
    _socket.listen("notification:new", callback);
    _socket.listen("notification", callback);
  }

  /// Ticket created event
  void onTicketCreated(Function(dynamic data) callback) {
    _socket.listen("ticket:created", callback);
  }

  /// Ticket updated event (status, assignment, etc.)
  void onTicketUpdated(Function(dynamic data) callback) {
    _socket.listen("ticket:update", callback);
    _socket.listen("ticket:updated", callback);
  }

  /// Ticket assigned event
  void onTicketAssigned(Function(dynamic data) callback) {
    _socket.listen("ticket:assigned", callback);
  }

  /// Comment added to a ticket room
  void onCommentAdded(Function(dynamic data) callback) {
    _socket.listen("comment:update", callback);
    _socket.listen("comment:new", callback);
    _socket.listen("comment-added", callback);
  }

  /// Dashboard updated (admin room)
  void onDashboardUpdated(Function(dynamic data) callback) {
    _socket.listen("dashboard:update", callback);
    _socket.listen("dashboard:updated", callback);
  }

  /// Remove a specific event listener
  void remove(String event) {
    _socket.remove(event);
  }

  /// Remove all event listeners
  void removeAll() {
    _socket.removeAll();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
