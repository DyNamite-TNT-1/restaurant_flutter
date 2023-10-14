import 'package:restaurant_flutter/models/service/message.dart';

class ClientMessageModel {
  final List<MessageDetailModel> messages;

  ClientMessageModel({
    this.messages = const [],
  });

  factory ClientMessageModel.fromJson(Map<String, dynamic> json) {
    return ClientMessageModel(
      messages: MessageDetailModel.parseListItem(json["allMessage"]),
    );
  }
}
