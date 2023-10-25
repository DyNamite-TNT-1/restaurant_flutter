import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  static IO.Socket? socket;

  static void connectSocket() {
    socket = IO.io(
      Api.branchGetter(),
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    socket!.onConnect((_) {
      UtilLogger.log('🚀 Socket connect');
    });
    socket!.onDisconnect((_) => UtilLogger.log('🚀 Socket disconnect'));
  }

  ///Singleton factory
  static final SocketClient _instance = SocketClient._internal();

  factory SocketClient() {
    return _instance;
  }

  SocketClient._internal();
}
