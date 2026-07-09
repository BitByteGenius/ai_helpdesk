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

  /// Connect Socket
  void connect() {
    if (_socket != null && _socket!.connected) {
      return;
    }

    _socket = io.io(
      ApiConstants.baseUrl.replaceAll("/api", ""),
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
      debugPrint("Socket Error : $data");
    });

    _socket!.onError((data) {
      debugPrint("Socket Error : $data");
    });
  }

  /// Disconnect
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  /// Join User Room
  void join(String userId) {
    if (_socket == null) return;

    _socket!.emit(
      "join",
      userId,
    );
  }

  /// Generic Emit
  void emit(
    String event,
    dynamic data,
  ) {
    _socket?.emit(event, data);
  }

  /// Listen Event
  void listen(
    String event,
    Function(dynamic) callback,
  ) {
    _socket?.on(
      event,
      callback,
    );
  }

  /// Remove Listener
  void remove(String event) {
    _socket?.off(event);
  }

  /// Remove All Listeners
  void removeAll() {
    _socket?.clearListeners();
  }
}