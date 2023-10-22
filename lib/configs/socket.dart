import 'package:restaurant_flutter/api/api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  static IO.Socket? socket;

  static void connectSocket() {
    socket = IO.io(
      Api.branchGetter(),
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'username': "ANHDUC"}).build(),
    );
  }

  ///Singleton factory
  static final SocketClient _instance = SocketClient._internal();

  factory SocketClient() {
    return _instance;
  }

  SocketClient._internal();
}
