// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:frontend/core/constant/api_constant.dart';

class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  io.Socket? _socket;

  io.Socket get socket => _socket!;

  bool get isConnected => _socket?.connected ?? false;

  /// Connect to the Socket.IO server
  void connect() {
    if (_socket != null && _socket!.connected) {
      return;
    }

    // Strip /api/ suffix — socket connects to the server root
    final serverUrl = ApiConstants.baseUrl.replaceAll("/api/", "");

    _socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint("🟢 Socket Connected");
    });

    _socket!.onDisconnect((_) {
      debugPrint("🔴 Socket Disconnected");
    });

    _socket!.onConnectError((data) {
      debugPrint("🔴 Socket Connect Error: $data");
    });

    _socket!.onError((data) {
      debugPrint("🔴 Socket Error: $data");
    });
  }

  /// Disconnect and clean up
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  /// Join personal user room (for direct notifications)
  void join(String userId) {
    if (_socket == null) return;
    _socket!.emit("join", userId);
    _socket!.emit("join-room", userId);
  }

  /// Join a ticket room for real-time comments
  void joinTicketRoom(String ticketId) {
    if (_socket == null) return;
    _socket!.emit("join-ticket", ticketId);
    _socket!.emit("join-ticket-room", ticketId);
  }

  /// Leave a ticket room
  void leaveTicketRoom(String ticketId) {
    if (_socket == null) return;
    _socket!.emit("leave-ticket", ticketId);
    _socket!.emit("leave-ticket-room", ticketId);
  }

  /// Join admin broadcast room
  void joinAdminRoom() {
    if (_socket == null) return;
    _socket!.emit("join-admin");
  }

  /// Generic emit
  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  /// Listen to an event
  void listen(String event, Function(dynamic) callback) {
    _socket?.off(event);
    _socket?.on(event, callback);
  }

  /// Remove a single event listener
  void remove(String event) {
    _socket?.off(event);
  }

  /// Remove all event listeners
  void removeAll() {
    _socket?.clearListeners();
  }
}
